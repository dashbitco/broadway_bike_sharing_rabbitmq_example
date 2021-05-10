alias BikeSharing.Repo
alias BikeSharing.Bike

for i <- 1..1000 do
  Repo.insert(%Bike{model: "Caloi 10"})
end
