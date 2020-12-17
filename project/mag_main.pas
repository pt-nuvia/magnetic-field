unit mag_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  TAGraph, TASeries,
  Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    btDraw: TButton;
    Chart1: TChart;
    LineSeries_Coil: TLineSeries;
    LineSeries_Line: TLineSeries;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btDrawClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
  const
  PI = 3.141592653589793;
  var
  x_ini, y_ini : double;
  r_of_coil : double;                                 //radius of coil
  plot_xmin,plot_xmax, plot_ymin, plot_ymax : double; // plot sizes
  dxy : double;                                       // drawing segment length
  r_start, r_max : double;          // min and max distances for plotting
  n_lines : integer;                // number of lines per semisphere


  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.FormCreate(Sender: TObject);
begin
  x_ini := 0.3;
  y_ini := 3;
  r_of_coil := 0.2;
  r_start := 3;
  r_max := 100;
  plot_xmin := -r_max;
  plot_xmax := r_max;
  plot_ymin := -0;
  plot_ymax := r_max;
  dxy := 0.5;
  n_lines := 111;

  Chart1.Extent.XMin := plot_xmin;
  Chart1.Extent.XMax := plot_xmax;
  Chart1.Extent.YMin := plot_ymin;
  Chart1.Extent.YMax := plot_ymax;
  Chart1.Extent.UseXMin := true;
  Chart1.Extent.UseXMax := true;
  Chart1.Extent.UseYMin := true;
  Chart1.Extent.UseYMax := true;

  LineSeries_Coil.AddXY(-r_of_coil, 0);
  LineSeries_Coil.AddXY(r_of_coil, 0);

end;

procedure TForm1.btDrawClick(Sender: TObject);
var
  new_line_series : TLineSeries;
  i : integer;
  x1, x2, y1, y2 : double;
  theta, alfa : double;
  Br, Btheta : double;
  d_x : double;   // increment of x defined by number of lines per semisphere

begin
  d_x := 2*(r_start)/(n_lines +1);
  Chart1.ClearSeries;
  Chart1.Proportional:= true;

  for i := 1 to n_lines do
  begin
    x1 := -r_start + d_x*i;
    y1 := sqrt(r_start*r_start - x1*x1);
    new_line_series := TLineSeries.Create(self);
    new_line_series.LinePen.Color:=clRed;

    while ( (x1 >= plot_xmin) AND (x1 <= plot_xmax) AND
            (y1 >= plot_ymin) AND (y1 <= plot_ymax) ) do
    begin
      theta := arctan2(x1, y1);
      Br := 2 * cos(theta);
      Btheta := sin(theta);
      alfa := arctan2(Btheta, Br);
      x2 := x1 + dxy*sin(theta + alfa);
      y2 := y1 + dxy*cos(theta + alfa);
      new_line_series.AddXY(x2, y2);
      x1 := x2;
      y1 := y2;
    end;
    Chart1.AddSeries(new_line_series);

  end;
  new_line_series := TLineSeries.Create(self);
  new_line_series.LinePen.Color:=clBlack;
  new_line_series.LinePen.Width:= 5;
  new_line_series.AddXY(-r_of_coil, 0);
  new_line_series.AddXY(r_of_coil, 0);
  Chart1.AddSeries(new_line_series);


end;


end.

