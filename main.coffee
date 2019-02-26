import fs from 'fs'

# find closest to equal partition
group_sizes = (input) ->
  students = input.students
  nb_students = students.length
  remainder = nb_students % input.groups
  min_group_size = (nb_students - remainder) / input.groups
  if remainder
  then [(min_group_size + 1 for [1..remainder])...,
    (min_group_size for [remainder + 1..input.groups])...]
  else (min_group_size for [1..input.groups])


# Three rules that groups must adhere to
is_quiet = (group) ->
  group
    .filter((student) -> student.noisy)
    .length < 3

understands = (group) ->
  group
    .filter((student) -> student.understands)
    .length > 0

is_peaceful = (group) ->
  fighters = (student.name for student in group)
  fightees = [].concat.apply([], (student.fights_with for student in group))
  not fightees.filter((student_name) -> -1 != fighters.indexOf(student_name)).length

# Test for the a class partition that fits the rules
fit_rules = (groups) ->
  groups.every((group) -> is_quiet(group) and understands(group) and is_peaceful(group))

# Quick reality check for easy fail conditions
maybe_quiet_groups = (input) ->
  input.students
    .filter((student) -> student.noisy)
    .length <= 2 * input.groups

maybe_understanding_groups = (input) ->
  input.students
    .filter((student) -> student.understands)
    .length >= input.groups

# Array permutation generator,
# credit https://stackoverflow.com/questions/9960908/permutations-in-javascript
permute = (permutation) ->
  length = permutation.length
  c = (0 for [1..length])
  i = 1
  yield permutation.slice()
  while (i < length)
    if c[i] < i
      k = i % 2 and c[i]
      p = permutation[i]
      permutation[i] = permutation[k]
      permutation[k] = p
      ++c[i]
      i = 1
      yield permutation.slice()
    else
      c[i] = 0
      ++i

# Given an ordered array, split it to match target sizes.
# Lot of inefficient overlap using above permutation generator
partition_arrangement = (arrangement) ->
  partition=[]
  current_index = 0
  for group_size in group_sizes(input)
    partition.push(arrangement[current_index..current_index + group_size - 1])
    current_index += group_size
  partition

# Prettier than the actual Student object
partition_format = (partition) ->
  ((student.name for student in group) for group in partition)

find_possible_partition = (input) ->
  unless maybe_understanding_groups(input) and maybe_quiet_groups(input)
    return {error: "impossible, too few groups!"}
  for arrangement from permute(input.students)
    partition = partition_arrangement(arrangement)
    if fit_rules(partition)
      return partition_format(partition)
  {error: "impossible"}

# load file
if process.argv.length == 3
  argument = process.argv.pop()
  if argument[-5..] == ".json"
    input = JSON.parse fs.readFileSync(argument)
    console.log find_possible_partition(input)
else
    console.log '{ "error": "please input filename as argument" }'
