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
# Nasz wz�r na regresj�: Husband = 0.83292*Wife + 37.81005.
# Na podstawie tego wzoru mo�esz przewidzie� wzrost m�a znaj�c wzrost �ony.

# Adjusted R-squared = 0.5783, zatem zmienna zale�na jest w oko�o 58% wyja�niona przez zmienn� niezale�n�
# (im R^2 jest bli�szy zeru, tym lepiej; dobrze dopasowany model to taki powy�ej 0.6).

# Estymatory wyrazu wolnego i wsp�czynnika kierunkowego s� istotne statystycznie:
# wyraz wolny (Intercept) na poziomie istotno�ci 0,01,
# wsp�czynnik kierunkowy (Wife) na poziomie istotno�ci 0,001.
# ��cznie wsp�czynniki regresji s� istotne statystycznie, czy istniej� zale�no�ci mi�dzy zmiennymi.

ggplot(dane, mapping = aes(x = Wife, y = Husband)) +
  geom_point() +
  geom_smooth(method = lm)

coef(model) #wsp�czynniki modelu
confint(model) #przedzia�y ufno�ci dla parametr�w
fitted(model) #warto�ci dopasowane przez model
vcov(model) #macierz kowariancji parametr�w
plot(model)

