Add-Type -AssemblyName System.Windows.Forms

function CreateForm {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Overlay UI Example'
    $form.Size = New-Object System.Drawing.Size(300, 200)
    $form.StartPosition = 'Manual'
    $form.TopMost = $true
    $form.Location = New-Object System.Drawing.Point(0, 0)
    return $form
}

function CreateLabel {
    $label = New-Object System.Windows.Forms.Label
    $label.Text = 'Hello, this is an overlay UI!'
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(50, 50)
    return $label
}

function CreateButton {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = 'Click Me'
    $button.Size = New-Object System.Drawing.Size(100, 30)
    $button.Location = New-Object System.Drawing.Point(100, 100)
    $button.BackColor = [System.Drawing.Color]::LightBlue
    $button.ForeColor = [System.Drawing.Color]::DarkBlue
    $button.Font = New-Object System.Drawing.Font('Arial', 10, [System.Drawing.FontStyle]::Bold)
    $button.Add_Click({ OnButtonClick })
    return $button
}

function OnButtonClick {
    [System.Windows.Forms.MessageBox]::Show("Button was clicked!")
}

function CloseForm {
    $form.Close()
}

$form = CreateForm
$label = CreateLabel
$button = CreateButton

$form.Controls.Add($label)
$form.Controls.Add($button)

$form.ShowDialog()