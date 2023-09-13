// @generated automatically by Diesel CLI.

diesel::table! {
    documents (id) {
        id -> Int4,
        title -> Varchar,
        url -> Text,
    }
}
