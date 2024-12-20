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

function CloseForm($form) {
    $form.Invoke([action] { $form.Close() })
}

function ShowForm($form) {
    $form.ShowDialog()
}

function UpdateLabelText($label, $newText) {
    $label.Invoke([action] { $label.Text = $newText })
}

function SetUpdateTimer($label, $form, [ref]$counter) {
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 1000 # 1 second
    $timer.Add_Tick({
        UpdateLabelText $label "Text updated to $($counter.Value)!"
        $counter.Value = $counter.Value + 1
        Write-Host "Counter: $($counter.Value)"
        # CloseForm $form
    })
   $timer.Start()
    return $timer
}

$form = CreateForm
$label = CreateLabel
# $dialogButton = CreateButton
$counter = [ref]3

$form.Controls.Add($label)
# $form.Controls.Add($dialogButton)

# $timer = SetUpdateTimer $label $form $counter
$form.Add_FormClosed({ $timer.Stop() })

function CreateLogButton {
    $logButton = New-Object System.Windows.Forms.Button
    $logButton.Text = 'Capture Logs'
    $logButton.Size = New-Object System.Drawing.Size(120, 30)
    $logButton.Location = New-Object System.Drawing.Point(100, 80)
    $logButton.BackColor = [System.Drawing.Color]::LightGreen
    $logButton.ForeColor = [System.Drawing.Color]::DarkGreen
    $logButton.Font = New-Object System.Drawing.Font('Arial', 10, [System.Drawing.FontStyle]::Bold)
    $logButton.Add_Click({
        [System.Windows.Forms.MessageBox]::Show("Logs captured!")
    })
    return $logButton
}

$logButton = CreateLogButton
$form.Controls.Add($logButton)
ShowForm $form
