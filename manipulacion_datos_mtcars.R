# Instalar librerías si no están instaladas
if (!require(dplyr)) install.packages("dplyr")
if (!require(tidyr)) install.packages("tidyr")

# Cargar librerías
library(dplyr)
library(tidyr)

# Cargar datos
data(mtcars)
df <- as.data.frame(mtcars)  # Convertirlo en un dataframe si es necesario

# 2. Selección de columnas y filtrado de filas
df_filtered <- df %>%
  select(mpg, cyl, hp, gear) %>%
  filter(cyl > 4)

# Imprimir el dataframe para verificar
print("Dataframe filtrado:")
print(df_filtered)

# 3. Ordenación y renombrado de columnas
df_sorted <- df_filtered %>%
  arrange(desc(hp)) %>%
  rename(consumo = mpg, potencia = hp)

# Imprimir el dataframe para verificar
print("Dataframe ordenado y renombrado:")
print(df_sorted)
# 4. Creación de nuevas columnas y agregación de datos
df_aggregated <- df_sorted %>%
  mutate(eficiencia = consumo / potencia) %>%
  group_by(cyl, gear) %>%  # Incluir gear en el group_by
  summarise(consumo_medio = mean(consumo), potencia_max = max(potencia))

# Verificar que el dataframe tiene gear
print("Dataframe con eficiencia y agregación:")
print(df_aggregated)

# 5. Creación del segundo dataframe y unión de dataframes
df_transmision <- data.frame(
  gear = c(3, 4, 5),
  tipo_transmision = c("Manual", "Automática", "Semiautomática")
)

# Realizar left join
df_joined <- left_join(df_aggregated, df_transmision, by = "gear")

# Imprimir el dataframe para verificar
print("Dataframe después de la unión:")
print(df_joined)


# 6. Transformación de formatos
# Usar pivot_longer para pasar a formato largo
df_long <- df_joined %>%
  pivot_longer(cols = c(consumo, potencia, eficiencia), names_to = "medida", values_to = "valor")

# Verificar el formato largo
print("Dataframe en formato largo:")
print(df_long)

# Identificar y manejar duplicados: Agrupamos por cyl, gear, tipo_transmision y medida
df_long_no_duplicates <- df_long %>%
  group_by(cyl, gear, tipo_transmision, medida) %>%
  summarise(valor = mean(valor), .groups = "drop")  # Promediamos los valores duplicados

# Verificar después de manejar duplicados
print("Dataframe después de manejar duplicados:")
print(df_long_no_duplicates)

# Usar pivot_wider para volver a formato ancho
df_wide <- df_long_no_duplicates %>%
  pivot_wider(names_from = medida, values_from = valor)

# Verificar el formato ancho
print("Dataframe en formato ancho:")
print(df_wide)
