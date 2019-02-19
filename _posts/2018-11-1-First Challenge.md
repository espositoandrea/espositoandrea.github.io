---
layout: post
author: Andrea Esposito
title: First Challenge
categories: [cpp, challenge]
tags: [cpp, challenge, coding, add, function]
image: "https://espositoandrea.github.io/assets/images/challenge-1.jpg"
---
Here I'll present two challenges along with two possible solutions in C++. The goal is to create a function that, given two positive values, returns their sum. Before reading the solutions, try finding one by yourself!

<!--more-->

## Challenge 1: Medium

The challenge is that the function cannot use any arithmetic operators (`+`, `-`, `*`, `/`, `++`, `--`, etc.). 

### The solution

{% highlight cpp %}
int add(int a, int b)
{
	return (b == 0)? a : add(a ^ b, (a & b) << 1);
}
{% endhighlight %}

## Challenge 2: Advanced

The challenge is that the function cannot use any arithmetic or logical operators.

### The solution

Note that in this solution, the operator `<<` isn't used as a logical left shift, but as an operator of the `std::ostringstream`.

{% highlight cpp %}
#include <iomanip>
#include <string>
#include <sstream>

int add(int a, int b)
{
	std::ostringstream s;
	if(a)
		s << std::setw(a) << " ";
	if(b) 
		s << std::setw(b) << " ";
	return s.str().size();
}
{% endhighlight %}
