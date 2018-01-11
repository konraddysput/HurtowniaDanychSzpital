dane <- read.csv('Wzrost-Maz-Zona.csv', header = TRUE, sep = ";")
dane
summary(dane)
library(ggplot2)
ggplot(dane, mapping = aes(x = Wife, y = Husband)) +
         geom_point()
#dodatnia korelacja

#regresja liniowa
model <- lm(Husband~Wife, data = dane)
summary(model)
# Nasz wzór na regresjê: Husband = 0.83292*Wife + 37.81005.
# Na podstawie tego wzoru mo¿esz przewidzieæ wzrost mê¿a znaj¹c wzrost ¿ony.

# Adjusted R-squared = 0.5783, zatem zmienna zale¿na jest w oko³o 58% wyjaœniona przez zmienn¹ niezale¿n¹
# (im R^2 jest bli¿szy zeru, tym lepiej; dobrze dopasowany model to taki powy¿ej 0.6).

# Estymatory wyrazu wolnego i wspó³czynnika kierunkowego s¹ istotne statystycznie:
# wyraz wolny (Intercept) na poziomie istotnoœci 0,01,
# wspó³czynnik kierunkowy (Wife) na poziomie istotnoœci 0,001.
# £¹cznie wspó³czynniki regresji s¹ istotne statystycznie, czy istniej¹ zale¿noœci miêdzy zmiennymi.

ggplot(dane, mapping = aes(x = Wife, y = Husband)) +
  geom_point() +
  geom_smooth(method = lm)

coef(model) #wspó³czynniki modelu
confint(model) #przedzia³y ufnoœci dla parametrów
fitted(model) #wartoœci dopasowane przez model
vcov(model) #macierz kowariancji parametrów
plot(model)

