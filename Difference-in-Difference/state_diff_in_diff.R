# Let's assume 0/1 treatment
# delta t > t0 equals 1 once recapitalization has happened.
# Data:
# t: time relative to the recapitalization in state A
# y: bank-lending at the state level
# state: string variable indicating the state
# Find beta

# two sequences for each state
t <- c(seq(-5, 5, 1), seq(-5, 5, 1))
y <- c(
    # state B lending from t = -5, to t = 5
    seq(10, 20, 1),
    # state A lending from t = -5 to t = 0
    seq(12, 17, 1),
    # state A after treatment values
    23,
    25,
    seq(25, 27)
)
state_data_points_count <- length(t) / 2
state <- c(rep("b", state_data_points_count), rep("a", state_data_points_count))
plot(
    t[1:state_data_points_count],
    y[c(TRUE, FALSE)],
    type = "n",
    main = "Diff-in-Diff between State A and State B",
    xlab = "Time",
    ylab = "Lending"
)
axis(1, at = t[1:state_data_points_count])
# state B
lines(t[1:state_data_points_count], y[1:state_data_points_count], col = "blue")
# state A
lines(
    t[1:state_data_points_count],
    y[(state_data_points_count + 1):22],
    col = "red"
)
abline(v = 0)
lines(0:5, (y[6:11] + 2), type = "l", lty = 2, col = "red")
legend(
    "topleft",
    inset = .02,
    box.lty = 0,
    legend = c("State B", "State A", "A Counterfactual"),
    col = c("blue", "red", "red"),
    cex = 1.2,
    lty = c(1, 1, 2)
)

# Create treatment variable
recap <- rep(0, length(t))
# Set treatment for State A after period 0
recap[t > 0 & state == "a"] <- 1
regression <- lm(y ~ recap + factor(t) + factor(state))
summary(regression) # beta is 5.2

# Add continuous treatment
