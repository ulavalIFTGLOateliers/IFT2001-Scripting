use std::env;
use std::time::Duration;

use actix_web::{App, error, get, HttpResponse, HttpServer, post, Responder, web};
use diesel::migration::MigrationConnection;
use diesel::prelude::*;
use diesel::r2d2::{ConnectionManager, Pool};
use diesel_migrations::{embed_migrations, EmbeddedMigrations, MigrationHarness};
use dotenv::dotenv;
use serde::{Deserialize, Serialize};

use schema::documents;
use schema::documents::dsl::documents as all_docs;

mod schema;

pub const MIGRATIONS: EmbeddedMigrations = embed_migrations!("migrations");

#[derive(Deserialize)]
struct DocumentCreation {
    title: String,
    url: String,
}

#[derive(Debug, Serialize, Insertable, Queryable)]
#[diesel(table_name = crate::schema::documents)]
struct Document {
    id: i32,
    title: String,
    url: String,
}

type DbPool = Pool<ConnectionManager<PgConnection>>;

pub fn wait_init_pool() -> Pool<ConnectionManager<PgConnection>> {
    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    loop {
        let manager = ConnectionManager::<PgConnection>::new(&database_url);
        if let Ok(pool) = Pool::builder().build(manager) {
            let mut conn = pool.get().expect("couldn't get db connection from pool");
            println!("Running setup");
            conn.setup().expect("error setuping dataset");
            println!("Running migrations");
            conn.run_pending_migrations(MIGRATIONS).expect("error running migrations");
            return pool;
        }
        let duration = Duration::from_millis(500);
        println!("Could not connect to database, waiting {:?}", duration);
        std::thread::sleep(duration);
    }
}

#[get("/documents")]
async fn get_documents(pool: web::Data<DbPool>) -> actix_web::Result<impl Responder> {
    println!("[GET] /");
    let docs: Vec<Document> = web::block(move || {
        let mut conn = pool.get().expect("couldn't get db connection from pool");
        all_docs.load::<Document>(&mut conn)
    })
        .await?
        .map_err(error::ErrorInternalServerError)?;

    Ok(HttpResponse::Ok().json(docs))
}

#[post("/documents")]
async fn create_document(doc: web::Json<DocumentCreation>, pool: web::Data<DbPool>) -> actix_web::Result<impl Responder> {
    println!("[POST] /echo");
    web::block(move || {
        let mut conn = pool.get().expect("couldn't get db connection from pool");
        diesel::insert_into(documents::table)
            .values((
                documents::title.eq(&doc.title),
                documents::url.eq(&doc.url),
            ))
            .execute(&mut conn)
    }).await?
        .map_err(error::ErrorInternalServerError)?;
    Ok(HttpResponse::Ok().body("ok"))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();
    let port = 8081;

    let pool = wait_init_pool();

    println!("Starting server on port {}", port);
    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(pool.clone()))
            .service(get_documents)
            .service(create_document)
    })
        .bind(("0.0.0.0", port))?
        .run()
        .await
}
