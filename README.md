# coffeescript-test
Simple test to get acquainted with coffeescript

Basic, inefficient solution to a constrained partitioning problem: how to split a class with students that may be noisy, understand the class or fight among each other given a set of rules.
- No child should be in a group with people that may fight with them.
- At least one child should understand classes inside each group
- Not more than two noisy people per group.

Here is a greedy approach, that tries every possible partition until a solution is reached.
Even more inefficient than that since every possible permutation of the class students can be tried, and several configurations of the same group may be tried several times.

Easy impossible cases are ironed out before trying class permutations, then all class permutations (n!) are tested in the worst case scenario. Only practiclal to about 11 or 12 students.
