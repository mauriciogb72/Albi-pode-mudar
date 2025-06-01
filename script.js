document.addEventListener('DOMContentLoaded', (event) => {
    loadComments(); // Carrega os comentários quando a página é carregada
});

function enterSite() {
    document.getElementById('welcome-section').style.display = 'none';
    document.getElementById('home-page').style.display = 'block';
}

function showSection(sectionId) {
    // Oculta todas as seções
    document.querySelectorAll('div[id]').forEach(div => {
        div.style.display = 'none';
    });

    // Exibe a seção selecionada
    const sectionToShow = document.getElementById(sectionId);
    sectionToShow.style.display = 'block';
}

function adicionarComentario(section) {
    const nome = document.getElementById(`nome-${section}`).value;
    const comentario = document.getElementById(`comentario-${section}`).value;
    const listaComentarios = document.getElementById(`lista-comentarios-${section}`);

    if (nome && comentario) {
        const novoComentario = document.createElement('div');
        novoComentario.innerHTML = `<strong>${nome}</strong>: ${comentario}`;
        listaComentarios.appendChild(novoComentario);

        // Salva o comentário no localStorage
        saveComment(section, nome, comentario);

        // Limpa os campos de entrada
        document.getElementById(`nome-${section}`).value = '';
        document.getElementById(`comentario-${section}`).value = '';
    } else {
        alert("Por favor, preencha todos os campos.");
    }
}

function saveComment(section, name, comment) {
    // Obtém os comentários existentes ou cria um novo objeto vazio
    let comments = JSON.parse(localStorage.getItem('comments')) || {};
    
    // Se a seção não existir, cria uma nova
    if (!comments[section]) {
        comments[section] = [];
    }

    // Adiciona o novo comentário à seção correspondente
    comments[section].push({ name, comment });

    // Salva os comentários de volta no localStorage
    localStorage.setItem('comments', JSON.stringify(comments));
}

function loadComments() {
    let comments = JSON.parse(localStorage.getItem('comments')) || {};
    
    // Carrega os comentários de cada seção
    for (let section in comments) {
        const listaComentarios = document.getElementById(`lista-comentarios-${section}`);
        
        if (listaComentarios) { // Verifica se o elemento existe
            comments[section].forEach(({ name, comment }) => {
                const novoComentario = document.createElement('div');
                novoComentario.innerHTML = `<strong>${name}</strong>: ${comment}`;
                listaComentarios.appendChild(novoComentario);
            });
        } else {
            console.error(`Elemento com ID lista-comentarios-${section} não encontrado.`);
        }
    }
}

