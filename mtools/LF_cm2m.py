#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 12 12:12:36 2019
@author: naw021

[cmmt by kxu4143 on Fri June 4 2021]
1/ change the input LF time series unit from cm/* to m/*
2/ delete the headlines for further use
"""

import numpy as np
import glob


filenames = glob.glob('*-lf.bbp')
for f in filenames:
    lf = np.loadtxt(f)
    lf[:,1:4] = lf[:,1:4] / 100
    np.savetxt(f, lf, fmt='%14.7e',delimiter='  ')
