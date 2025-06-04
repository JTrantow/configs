#!/usr/bin/python

import string

#
# Header for the output file.
#
print("digraph hal_nets {")
print("""
graph [
rankdir = "LR"
];
node [
fontsize = "8"
];
""")

# defs
f = open("pin.out", "r")

component_hash={}

#
# Create a component hash of all the different components and pin_names.
#
for line in f:
        comp_name, pin_type, pin_dir, pin_value, pin_name = line.split()[:5]
        if comp_name not in component_hash:
                component_hash[comp_name] = [];
        component_hash[comp_name].append(pin_name)

for comp in list(component_hash.keys()):
        # dot records don't like '-' or '.' in the field name.
        comp_labels = ["<" + c.replace('-','_').replace('.','_') + "> " + c for c in component_hash[comp]]
        print("\"" + comp + "\"" + " [")
        sep = " | "
        print("\tlabel = " + "\"" + sep.join(comp_labels) + "\"")
        print("\tshape = \"record\"")
        print("]")
        print("\n")

def component(component_hash,pin):
        for lst in list(component_hash.values()):
                if pin in lst:
                        return list(component_hash.keys())[list(component_hash.values()).index(lst)]
#
# Use signal names from sig.out as labels instead of creating extra nodes. 
#
f = open("sig.out", "r")
net_list = []
for line in f:
        sig_list = line.split()

        sig_type, sig_value, signal_name = sig_list[0:3]    
        sig_declarations = sig_list[3:]
        #
        # Treat the remainder of the declaration as pairs of direction and component name.
        # The signal will become the dot label.
        # Each signal should have exactly one component source and zero or more destinations.

        for count in range(0, len(sig_declarations), 2):
                if sig_declarations[count] == "<==":
                        # This is a source for the signal.
                        src_pin = sig_declarations[count + 1]
                        src_comp = component(component_hash, src_pin)
                        if src_comp != None:
                                src_comp = "\"" + src_comp + "\"" + ":"
                        else:
                                src_comp = ""
                        break

        for count in range(0, len(sig_declarations), 2):
                if sig_declarations[count] ==  "==>":
                        # This is a destination for the signal.
                        dst_pin = sig_declarations[count + 1]
                        dst_comp = component(component_hash, dst_pin)
                        if dst_comp != None:
                                dst_comp = "\"" + dst_comp + "\"" + ":"
                        else:
                                dst_comp = ""
                        # Dot doesn't like record field names with '-' or '.'.
                        net_list.append(src_comp + src_pin.replace('-','_').replace('.','_') + " -> " + dst_comp + dst_pin.replace('-','_').replace('.','_') + ' [label="' + signal_name + '"]')                 
                elif sig_declarations[count] != "<==" :
                        print("expected <== or ==>")

for line in net_list:
        print(line + ";")

print("}")