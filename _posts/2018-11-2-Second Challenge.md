---
layout: post
author: Andrea Esposito
title: Second Challenge
categories: [cpp, challenge]
tags: [cpp, challenge, coding, add, function]
image: "https://espositoandrea.github.io/assets/images/challenge-2.jpg"
---
Here I'll present one more challenge along with two possible solutions in C++. The goal is to create a function that, given two positive values, swaps them. Before reading the solutions, try finding one by yourself!

<!--more-->

## The challenge
The challenge consists in swapping the two values without using a third one.

### The first solution

This solution uses the basic arithmetic operators `+` (sum) and `-` (subtraction).

{% highlight cpp %}
void swapNoThirdVar(int &a, int &b)
{
	a += b;
	b = a - b;
	a -= b;
}
{% endhighlight %}

### The second solution

This solution uses the basic logic operator `^` (XOR).

{% highlight cpp %}
void swapNoThirdVar(int &a, int &b)
{
	a ^= b;
	b ^= a; 
	a ^= b;
}
{% endhighlight %}

