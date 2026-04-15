#!/bin/bash
dig +short A "$1" | head -n1
