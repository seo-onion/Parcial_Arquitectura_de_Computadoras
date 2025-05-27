#include <vector>
#include <iostream>

using namespace std;

std::vector<std::vector<int>> createArray() {
    std::vector<std::vector<int>> A(3, std::vector<int>(3));
    int value = 1;
    // Recorremos filas y columnas para asignar valores de 1 a 9
    for (size_t i = 0; i < A.size(); ++i) {
        for (size_t j = 0; j < A[i].size(); ++j) {
            A[i][j] = value++;
        }
    }
    return A;
}

void bubbleSortMatrix(std::vector<std::vector<int>>& A) {
    int rows = A.size();
    if (rows == 0) return;
    int cols = A[0].size();
    int N    = rows * cols;           // número total de elementos

    // Una pasada hunde el menor valor restante al final
    for (int pass = 0; pass < N - 1; ++pass) {
        // Recorremos de 0 hasta el último par no ordenado
        for (int k = 0; k < N - pass - 1; ++k) {
            int r1 = k / cols, c1 = k % cols;         // (fila,col) de k
            int r2 = (k + 1) / cols, c2 = (k + 1) % cols; // de k+1
            if (A[r1][c1] < A[r2][c2]) {               // si desordenados
                // intercambio manual
                int tmp     = A[r1][c1];
                A[r1][c1]   = A[r2][c2];
                A[r2][c2]   = tmp;
            }
        }
    }
}

int main() {
    //Crear e inicializar la matriz
    auto A = createArray();

    //Mostrar antes de ordenar
    cout << "Antes de ordenar:\n";
    for (auto& fila : A) {
        for (int x : fila) cout << x << ' ';
        cout << '\n';
    }
    cout << '\n';

    //Ordenar en orden descendente
    bubbleSortMatrix(A);

    //Mostrar después de ordenar
    cout << "Después de ordenar (descendente):\n";
    for (auto& fila : A) {
        for (int x : fila) cout << x << ' ';
        cout << '\n';
    }

    return 0;
}