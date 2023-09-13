import json
import urllib.request
from termcolor import colored

from state_machine import AbstractState, StateMachine, QuitState

BACKEND_URL = 'http://localhost:8080'


class MenuState(AbstractState):
    def execute(self):
        print(colored('Menu', 'green'))
        print(colored('1. Add endpoint', 'blue'))
        print(colored('2. Check endpoints', 'blue'))
        print(colored('3. Quit', 'red'))
        value = input('Enter your choice: ')
        if value == '1':
            self.next_state = AddEndpointState()
        elif value == '2':
            self.next_state = CheckEndpointsState()
        elif value == '3':
            self.next_state = QuitState()
        else:
            print('Invalid input')
            self.next_state = MenuState()


class AddEndpointState(AbstractState):
    def execute(self):
        name = input('Enter endpoint name: ')
        url = input('Enter endpoint url: ')

        payload = {
            'name': name,
            'url': url
        }
        data = json.dumps(payload).encode('utf-8')

        url = f'{BACKEND_URL}/endpoints'
        headers = {'Content-Type': 'application/json'}
        req = urllib.request.Request(url, data=data, method='POST', headers=headers)

        res = urllib.request.urlopen(req)
        if res.status != 200:
            print('Error adding endpoint')
        else:
            print('Endpoint added')

        self.next_state = MenuState()


class CheckEndpointsState(AbstractState):
    def execute(self):
        url = f'{BACKEND_URL}/endpoints'
        self.next_state = MenuState()
        req = urllib.request.Request(url, method='GET')
        res = urllib.request.urlopen(req)
        data = json.loads(res.read().decode('utf-8'))

        for i, endpoint in data.items():
            print(colored(f'{endpoint["name"]}', 'blue'))
            print(f'\tURL: {endpoint["url"]}')

            pings = endpoint["pings"]
            is_up = [ping["status"] == 'operational' for ping in pings]
            num_pings = len(pings)
            up_time = sum(is_up) / num_pings if num_pings > 0 else 0
            print(f'\tNumber of pings: {num_pings}')
            print(f'\tUp time: {up_time:.2f}')
            print(f'\tLatest status: ', end='')
            if num_pings > 0:
                status = pings[0]["status"]
                color = 'yellow'
                if status == 'operational':
                    color = 'green'
                elif status == 'down':
                    color = 'red'
                print(colored(f'\t{status}', color))
            else:
                print(colored('unknown', 'yellow'))
        self.next_state = MenuState()


if __name__ == '__main__':
    state_machine = StateMachine(MenuState())
    while not state_machine.is_finished():
        print('-' * 20)
        state_machine.execute()
        state_machine.transition()
