﻿using System;
using System.Windows.Forms;
using System.IO.Ports;

namespace sw
{
    public partial class Form1 : Form
    {
        int count = 0;

        public Form1() { InitializeComponent(); }

        private void Form1_Load_1(object sender, EventArgs e)
        {
            string[] ports = SerialPort.GetPortNames();
            comboBox_COMP.Items.AddRange(ports);
        }

        private void comboBox_COMP_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (serialPort1.IsOpen) MessageBox.Show("Please close the connection first", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            else serialPort1.PortName = comboBox_COMP.Text;
        }
        
        private void button_connect_Click(object sender, EventArgs e)
        {
            if (comboBox_COMP.Text == "") MessageBox.Show("Please select a COM port", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            else
            {
                if (serialPort1.IsOpen) MessageBox.Show("Port is already open", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                else
                {
                    try
                    {
                        serialPort1.Open();
                        MessageBox.Show("Connection Opened", Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
                        textBox_Status.Text = "Connected";
                        textBox_Status.BackColor = System.Drawing.Color.Green;
                    }
                    catch (Exception)
                    {
                        MessageBox.Show("Error opening connection", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }
        }

        private void button_disconnect_Click(object sender, EventArgs e)
        {
            if (serialPort1.IsOpen)
            {
                serialPort1.Close();
                MessageBox.Show("Connection Closed", Text, MessageBoxButtons.OK, MessageBoxIcon.Information);
                textBox_Status.Text = "Disconnected";
                textBox_Status.BackColor = System.Drawing.Color.Red;
            }
            else MessageBox.Show("Connection is already closed", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }

        private void button_ON_Click(object sender, EventArgs e)
        {
            try
            {
                if (serialPort1.IsOpen) serialPort1.Write("@");
                else MessageBox.Show("Connection is closed", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            catch (Exception)
            {
                MessageBox.Show("Error sending data", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void button_OFF_Click(object sender, EventArgs e)
        {
            try
            {
                if (serialPort1.IsOpen) serialPort1.Write("$");
                else MessageBox.Show("Connection is closed", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            catch (Exception)
            {
                MessageBox.Show("Error sending data", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void serialPort1_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            string data = serialPort1.ReadExisting();
            this.Invoke(new EventHandler(delegate
            {
                if (data == "S")
                {
                    count++;
                    textBox_Counter.Text = count.ToString();
                }
            }));
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            DialogResult result = MessageBox.Show("Do you want to close the connection?", "Warning", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
            {
                if (serialPort1.IsOpen) serialPort1.Close();
                e.Cancel = false;
            }
            else e.Cancel = true;
        }

        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }
    }
}
