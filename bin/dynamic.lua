#!/usr/bin/env lua

local ui = require "tek.ui"

local APP_ID = "tekui-demo"
local VENDOR = "schulze-mueller.de"

ui.Application:new
{
	ApplicationId = APP_ID,
	VendorDomain = VENDOR,
	Children =
	{
		ui.Window:new
		{
			Title = "Dynamic Weight 1",
			Children =
			{
				ui.Group:new
				{
					Legend = "Dynamic Weight",
					Children =
					{
						ui.Group:new
						{
							Title = "Hallo",
							Width = "free",
							Children =
							{
								ui.Slider:new
								{
									Min = 0,
									Max = 100000,
									Notifications =
									{
										["Value"] =
										{
											[ui.NOTIFY_CHANGE] = {
												{ ui.NOTIFY_ID, "weight-1", "setValue", "Text", ui.NOTIFY_FORMAT, "%d" },
											},
										},
									},
								},
								ui.Text:new
								{
									FontSpec = "utopia:100",
									Id = "weight-1",
									Text = "0",
									Width = "auto"
								},
							},
						},
					},
				},
			},
		},
		ui.Window:new
		{
			Title = "Dynamic Weight 2",
			Legend = "Dynamic Weight",
			Orientation = "vertical",
			Children =
			{
				ui.Group:new
				{
					Children =
					{
						ui.Slider:new
						{
							Knob = ui.Text:new
							{
								Id = "slider-knob",
								Class = "button",
								Text = "$08000",
							},
							Id = "slider-2",
							Min = 0,
							Max = 0x10000,
							Width = "free",
							Default = 0x8000,
							Step = 0x400,
							Notifications =
							{
								["Value"] =
								{
									[ui.NOTIFY_CHANGE] =
									{
										{ ui.NOTIFY_ID, "slider-weight-1", ui.NOTIFY_FUNCTION, function(self, val)
											self:setValue("Text", ("$%05x"):format(val))
											self:setValue("Weight", val)
											self.Parent:calcWeights()
											self:rethinkLayout(1)
										end, ui.NOTIFY_VALUE }
									},
								},
							},
						},
						ui.Text:new
						{
							Mode = "button",
							Class = "button",
							Text = "Reset",
							Width = "auto",
							Notifications =
							{
								["Pressed"] =
								{
									[false] =
									{
										{
											ui.NOTIFY_ID, "slider-2", "reset"
										}
									}
								}
							}
						},
					},
				},
				ui.Group:new
				{
					Children =
					{
						ui.Text:new { Id="slider-weight-1", Text = " $08000 ", FontSpec="utopia:60", KeepMinWidth = true },
						ui.Frame:new { Height = "fill" },
					},
				},
			},
		},
		ui.Window:new
		{
			Title = "Dynamic Border Thickness",
			Legend = "Dynamic Border Thickness",
			Children =
			{
				ui.Text:new
				{
					Border = { 2, 2, 2, 2 },
					Mode = "button",
					Class = "button",
					Width = "auto",
					Id = "border-button",
					Text = "Watch borders",
				},
				ui.Slider:new
				{
					Border = { 2, 2, 2, 2 },
					Style = "border-rim-width: 1; border-focus-width: 1;",
					Width = "free",
					Value = 2,
					Min = 0,
					Max = 20,
					ForceInteger = true,
					Notifications =
					{
						["Value"] =
						{
							[ui.NOTIFY_CHANGE] =
							{
								{
									ui.NOTIFY_SELF, ui.NOTIFY_FUNCTION, function(self, val)
										local e = self.Application:getElementById("border-button")
										local b = e.Border
										b[1], b[2], b[3], b[4] = val, val, val, val
										e:rethinkLayout(1)
										local b = self.Border
										b[1], b[2], b[3], b[4] = val, val, val, val
										self:rethinkLayout(1)
									end, ui.NOTIFY_VALUE
								}
							}
						}
					},
				},
			},
		},
	},
}:run()

