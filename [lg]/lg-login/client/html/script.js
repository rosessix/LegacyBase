const app = new Vue({
    el: '#appcontainer',
    vuetify: new Vuetify(),

    data: () => ({
        show: true,
        creatingChar: false,
        page: 'welcome',
        loading: true,
        error: false,
        errorMsg: 'Der ser ud til der er sket en fejl',
        deletingCharacters: false,
        deletingChar: {},
        characters: [
            { firstname: 'Legacy', lastname: 'Base', id: 1, cash: 69420, balance: 42069, job: 'Arbejdsløs' },
            { firstname: 'James', lastname: 'Base', id: 1, cash: 69420, balance: 42069, job: 'Arbejdsløs' },
            { firstname: 'QB', lastname: 'Base', id: 1, cash: 69420, balance: 42069, job: 'Arbejdsløs' },
        ],

        firstnameInput: '',
        lastnameInput: '',
    }),

    methods: {
        changePage: function (page) {
            if (this.page == 'welcome') {
                // add class to welcome ubtton
                document.getElementById('welcomebutton').classList.toggle('animated');
                document.getElementById('createchar').classList.toggle('animated');
                console.log('added class')
            }
            this.page = page
        },

        deleteCharacter: function (item) {
            this.deletingCharacters = true
            this.deletingChar = item
        },

        deleteChar: function () {
            $.post('https://lg-login/deleteCharacter', JSON.stringify({id: this.deletingChar.id}))
            this.deletingCharacters = false
        },

        chooseCharacter: function (item) {
            console.log(item)
            $.post('https://lg-login/selectChar', JSON.stringify({id: item.id}))
        },

        createChar: function () {
            $.post('https://lg-login/createCharacter', JSON.stringify({
                firstname: this.firstnameInput,
                lastname: this.lastnameInput,
                birthday: document.getElementById('birthday').value,
            }))
        },

        setChars: function (data) {
            this.characters = data
        },


        showError: function (msg) {
            this.error = true
            this.errorMsg = msg
        }
    }
});

$(function () {
    // Listens for NUI messages from Lua 
    window.addEventListener('message', function (event) {
        let item = event.data;
        if (item.characters != undefined) {
            app.setChars(item.characters)
        }
        if (item.display != undefined) {
            app.show = item.display
            console.log(item.display, app.show)
        }

        if (item.error != undefined) {
            app.showError(item.error)
        }
    });
})

