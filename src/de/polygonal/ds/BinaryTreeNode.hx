/**
 * Copyright (c) Michael Baczynski 2007
 * http://lab.polygonal.de/ds/
 *
 * This software is distributed under licence. Use of this software
 * implies agreement with all terms and conditions of the accompanying
 * software licence.
 */
package de.polygonal.ds;

import haxe.Constraints.Function;

/**
	 * A binary tree node from which you can build a binary tree.
	 * 
	 * <p>A Binary Tree is a simplified tree structure in which every node is
	 * only allowed to have up to two children nodes, which are called
	 * the left and right child.</p>
	 */
class BinaryTreeNode
{
    /**
		 * Performs a <i>preorder traversal</i> on a tree.
		 * This processes the current tree node before its children.
		 * 
		 * @param node    The node to start from.
		 * @param process A process function applied to each traversed node.
		 */
    public static function preorder(node : BinaryTreeNode, process : Function) : Void
    {
        if (node != null)
        {
            process(node);
            
            if (node.left)
            {
                BinaryTreeNode.preorder(node.left, process);
            }
            
            if (node.right)
            {
                BinaryTreeNode.preorder(node.right, process);
            }
        }
    }
    
    /**
		 * Performs an <i>inorder traversal</i> on a tree.
		 * This processes the current node in between the children nodes.
		 * 
		 * @param node    The node to start from.
		 * @param process A process function applied to each traversed node.
		 */
    public static function inorder(node : BinaryTreeNode, process : Function) : Void
    {
        if (node != null)
        {
            if (node.left)
            {
                BinaryTreeNode.inorder(node.left, process);
            }
            
            process(node);
            
            if (node.right)
            {
                BinaryTreeNode.inorder(node.right, process);
            }
        }
    }
    
    /**
		 * Performs a <i>postorder traversal</i> on a tree.
		 * This processes the current node after its children nodes.
		 * 
		 * @param node    The node to start from.
		 * @param process A process function applied to each traversed node.
		 */
    public static function postorder(node : BinaryTreeNode, process : Function) : Void
    {
        if (node != null)
        {
            if (node.left)
            {
                BinaryTreeNode.postorder(node.left, process);
            }
            
            if (node.right)
            {
                BinaryTreeNode.postorder(node.right, process);
            }
            
            process(node);
        }
    }
    
    /**
		 * The left child node being referenced.
		 */
    public var left : BinaryTreeNode;
    
    /**
		 * The right child node being referenced.
		 */
    public var right : BinaryTreeNode;
    
    /**
		 * The parent node being referenced.
		 */
    public var parent : BinaryTreeNode;
    
    /**
		 * The node's data.
		 */
    public var data : Dynamic;
    
    /**
		 * Creates an empty node.
		 * 
		 * @param obj The data to store inside the node.
		 */
    public function new(obj : Dynamic)
    {
        this.data = data;
        parent = left = right = null;
    }
    
    /**
		 * Writes data into the left child.
		 * 
		 * @param obj The data.
		 */
    public function setLeft(obj : Dynamic) : Void
    {
        if (left == null)
        {
            left = new BinaryTreeNode(obj);
            left.parent = this;
        }
        else
        {
            left.data = data;
        }
    }
    
    /**
		 * Writes data into the right child.
		 * 
		 * @param obj The data.
		 */
    public function setRight(obj : Dynamic) : Void
    {
        if (right == null)
        {
            right = new BinaryTreeNode(obj);
            right.parent = this;
        }
        else
        {
            right.data = data;
        }
    }
    
    /**
		 * Checks if this node is left of its parent.
		 * 
		 * @return True if this node is left, otherwise false.
		 */
    public function isLeft() : Bool
    {
        return this == parent.left;
    }
    
    
    /**
		 * Check if this node is a right of its parent.
		 * 
		 * @return True if this node is right, otherwise false.
		 */
    public function isRight() : Bool
    {
        return this == parent.right;
    }
    
    /**
		 * Recursively calculates the depth of a tree.
		 * 
		 * @return The depth of the tree.
		 */
    public function getDepth(node : BinaryTreeNode = null) : Int
    {
        var left : Int = -1;
        var right : Int = -1;
        
        if (node == null)
        {
            node = this;
        }
        
        if (node.left)
        {
            left = getDepth(node.left);
        }
        
        if (node.right)
        {
            right = getDepth(node.right);
        }
        
        return as3hx.Compat.parseInt(Math.max(left, right) + 1);
    }
    
    /**
		 * Recursively counts the total number
		 * of nodes including this node.
		 */
    public function count() : Int
    {
        var c : Int = 1;
        
        if (left != null)
        {
            c += left.count();
        }
        
        if (right != null)
        {
            c += right.count();
        }
        
        return c;
    }
    
    /**
		 * Recursively clears the tree by deleting
		 * all child nodes underneath the node
		 * the method is called on.
		 */
    public function destroy() : Void
    {
        if (left != null)
        {
            left.destroy();
        }
        
        left = null;
        
        if (right != null)
        {
            right.destroy();
        }
        
        right = null;
    }
    
    /**
		 * Returns a string representing the current object.
		 */
    public function toString() : String
    {
        return "[BinaryTreeNode, data= " + data + "]";
    }
}
