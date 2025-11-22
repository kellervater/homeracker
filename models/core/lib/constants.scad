// HomeRacker - Core Constants
//
// Shared constants and measurements for the HomeRacker - Core system.
// Include this file in all core components to ensure consistency.
//
// MIT License
// Copyright (c) 2025 Patrick Pötz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// Tolerance for fitting parts together
tolerance = 0.2; // in mm

// Base printing parameters
printing_layer_width = 0.4; // in mm
printing_layer_height = 0.2; // in mm

// HR Base Measurements
base_unit = 15; // Base unit for all core measurements in mm
base_strength = 2; // Wall thickness in mm
base_chamfer = 1; // Chamfer size in mm

// Lock Pin Holes
lockpin_hole_chamfer = 0.8; // Chamfer size in mm
lockpin_hole_side_length = 4;
lockpin_hole_side_length_dimension = [lockpin_hole_side_length, lockpin_hole_side_length];


// HomeRacker Colors
HR_YELLOW = "#f7b600";
HR_BLUE = "#0056b3";
HR_RED = "#c41e3a";
HR_GREEN = "#2d7a2e";
HR_CHARCOAL = "#333333";
HR_WHITE = "#f0f0f0";
