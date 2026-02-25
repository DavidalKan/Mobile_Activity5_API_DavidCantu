What the app does
Muestra los pokemon extraidos desde la API https://pokeapi.co/ inicia con una pokebola que al darle click empieza a navegar por las generaciones de pokemon por una lista, al seleccionarlo da los detalles de la generación al mostrar otra lista pero ahora de los pokemon de esa generación y si seleccionas uno te dice su nombre, tipo y debilidades.
Which API it connects to (link the endpoint)
Se conecta a la API https://pokeapi.co/
How to run the app (Xcode version, iOS target, steps)
Dale click a la pokebola y navega a través de las 4 opciones de generaciones. Si deseas buscar un pokemon globalmente está la barra de búsqueda o si quieres ir por cada una generación para buscar el pokemon deseable ahí están disponibles. La información de los pokemon es su nobmre, tipo y debilidad. 
La versión de Xcode utilizada es la 26.2 y la app fue hecha para el iPhone 17 Pro.

Pokemon.swift (Modelo)

PokemonViewModel.swift (Lógica)

HomeView.swift (Inicio animado)

FilterView.swift (Buscador y Generaciones)

PokeListView.swift (Lista)

PokeRowView.swift (Fila)

PokeDetailView.swift (Detalle completo)
