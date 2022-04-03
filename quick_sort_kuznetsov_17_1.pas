program q_sort;

uses crt;

const n_seq = 100; n_list = 5;

type list = record
        fam : string;
        name : string;
        m : string;
        cm : string;
        h : integer;
     end;
     data = array[1..n_seq] of list;
     arr_str = array[1..n_list] of string;

var  arr_d : data;
     i, n,rlt_mode, mode, trade, step : integer;
     f_read, f_write, rlt_write : string;

function init_file() : string;
{Vvodim nazvanie faila posledovatelnosti}
    var n : integer;
    begin
        writeln();
        writeln('File numbers:');
        writeln('1  -  f_n_initial.txt');
        writeln('2  -  f_n_up.txt');
        writeln('3  -  f_n_down.txt');
        writeln('4  -  f_n_up_and_down.txt');
        writeln('5  -  f_n_random.txt');
        writeln();

        repeat
                write('Enter file number from 1 to 5: ');
                readln(n);
                if (n <= 0) or (n >= 6) then writeln('Bad number!!!');
        until (n >= 1) and (n <= 5);

        case n of
        1 : init_file :=  'f_n_initial.txt';
        2 : init_file :=  'f_n_up.txt';
        3 : init_file :=  'f_n_down.txt';
        4 : init_file :=  'f_n_up_and_down.txt';
        5 : init_file :=  'f_n_random.txt';
        end;

    end;

function init_num() : integer;
{Vvodim dlinu posledovatelnosti i rezhim raboty}
    var n : integer;
    begin
        repeat
                write('Enter the length of the sequence (0 < N <= 100): ');
                readln(n);
                if (n <= 0) or (n >= 101) then writeln('Bad number!!!');
        until (n >= 1) and (n <= 100);
        init_num := n;
    end;

function init_working() : integer;
{Vvodim rezhim raboty}
    var m : integer;
    begin
        repeat
                write('Enter the operating mode ( 1 - demonstration, 0 - working): ');
                readln(m);
                if (m <> 0) and (m <> 1) then writeln('Bad number!!!');
        until (m = 0) or (m = 1);
        init_working := m;
    end;

function init_result() : integer;
{Vvodim rezhim rezultatov}
    var m : integer;
    begin
        repeat
                write('Enter data recording mode ( 1 - Forming the table, 0 - single result): ');
                readln(m);
                if (m <> 0) and (m <> 1) then writeln('Bad number!!!');
        until (m = 0) or (m = 1);
        init_result := m;
    end;


procedure transform_str(str : string; var str_data : arr_str);
    var i, q, r : integer;

    begin

        for i := 1 to 2 do begin
                q := pos(' ', str);
                str_data[i] := copy(str, 1, q);
                delete(str, 1, q);
        end;
        str_data[5] := copy(str, 1, length(str));
        q := pos(' m', str) + 2;
        str_data[3] := copy(str, 1, q);
        r := pos(' cm', str) + 3;
        str_data[4] := copy(str, q, r);
    end;

function transform(str : string) : integer;
{Funcia preobrazuet stroku c znacheniami rosta, tipa: STR_2 m 9 cm;
v chislovoe znachenie rosta v cm, tipa: 209}

    var i, k, height : integer;
    begin
        i := 1;
        {Udaliaem probely, 'm', 'c' ==> privodim k vidu yyy ili yy}

        while (i <= length(str)) do begin
                if (str[i] = ' ') or (str[i] = 'm') or (str[i] = 'c') then begin
                        delete(str, i, 1); continue; end;
                inc(i);
        end;
        {Proveriaem na kol-vo simvolov, esli 2 ==> dobavliaem 0
        mezhdu nimi}
        if (length(str) = 2) then insert('0', str, 2);
        val(str, height, k);
        transform := height;
    end;


procedure data_read(file_name : string; n : integer; var data_r : data);
    var file_r : text;
        i : integer;
        str_r : string;
        arr_s : arr_str;

    begin
        assign(file_r, file_name);
        reset(file_r);
        for i := 1 to n do begin
                readln(file_r, str_r);
                transform_str(str_r, arr_s);
                data_r[i].fam := arr_s[1];
                data_r[i].name := arr_s[2];
                data_r[i].m := arr_s[3];
                data_r[i].cm := arr_s[4];
                data_r[i].h := transform(arr_s[5]);
        end;
        close(file_r);
    end;

procedure data_write( file_name : string; n : integer; data_w : data);
    var file_w_up : text; i : integer;

    begin
        assign(file_w_up, file_name);
        rewrite(file_w_up);
        for i := 1 to n do begin
                write(file_w_up, data_w[i].fam:14);
                write(file_w_up, data_w[i].name:14);
                write(file_w_up, data_w[i].m:6);
                writeln(file_w_up, data_w[i].cm:6);
        end;
        close(file_w_up);
    end;


procedure q_sort( f, n, len, mode : integer; var data_sort : data;
                                              var step, trade : integer);
    var i, j, k, sup_elm : integer; swp_list : list;

    begin
        i := f;
        j := n;
        sup_elm := data_sort[(i + j) div 2].h;

        repeat
                inc(step, 2);
                while data_sort[i].h < sup_elm do begin
                        inc(i);
                        inc(step);
                end;

                while data_sort[j].h > sup_elm do begin
                        dec(j);
                        inc(step);
                end;
                if i <= j then begin

                        if data_sort[i].h <> data_sort[j].h then begin
                                swp_list := data_sort[i];
                                data_sort[i] := data_sort[j];
                                data_sort[j] := swp_list;
                                inc(trade);

                                if (mode = 1) then begin
                                        writeln();
                                        writeln('Sorting trade:', trade:4);

                                        for k := 1 to len do begin
                                                writeln(data_sort[k].fam:14,
                                                        data_sort[k].name:14,
                                                        data_sort[k].m:5,
                                                        data_sort[k].cm:6);
                                        end;
                                end;
                        end;

                        inc(i);
                        dec(j);
                end;
        until i > j;

        if f < j then q_sort(f, j, len, mode, data_sort, step, trade);
        if i < n then q_sort(i, n, len, mode, data_sort, step, trade);

    end;

function table_write(f_write, rlt_write : string): string;
    const len_seq = 5; var_file = 5;
    var num, v_file, seq, mode, step, trade, i : integer;
        mid_step, mid_trade : real;
        f_read : string;
        arr_d : data;
        arr_rlt : array[1..var_file, 1..2] of integer;
        file_w : text;

    begin
        assign(file_w, rlt_write);
        rewrite(file_w);

        writeln(file_w, 'The sort table is <Quick sort>:');
        writeln(file_w, 'File numbers:');
        writeln(file_w, '1  -  f_n_initial.txt');
        writeln(file_w, '2  -  f_n_up.txt');
        writeln(file_w, '3  -  f_n_down.txt');
        writeln(file_w, '4  -  f_n_up_and_down.txt');
        writeln(file_w, '5  -  f_n_random.txt');
        writeln(file_w, '');

        for i := 1 to 69 do write(file_w,'-'); writeln(file_w,'');
        writeln(file_w, '|  n  |  parameter  |          sequence number          |  average  |');
        writeln(file_w, '|     |             |     1     2     3     4     5     |   value   |');
        for i := 1 to 69 do write(file_w,'-'); writeln(file_w, '');

        for num := 1 to len_seq do begin
                seq := init_num;
                mid_step := 0;
                mid_trade := 0;

                for v_file := 1 to var_file do begin
                        step := 0;
                        trade := 0;
                        case v_file of
                                1 : f_read :=  'f_n_initial.txt';
                                2 : f_read :=  'f_n_up.txt';
                                3 : f_read :=  'f_n_down.txt';
                                4 : f_read :=  'f_n_up_and_down.txt';
                                5 : f_read :=  'f_n_random.txt';
                        end;

                        mode := init_working;
                        data_read(f_read, seq, arr_d);
                        q_sort(1, seq, seq, mode, arr_d, step, trade);
                        data_write(f_write, seq, arr_d);
                        arr_rlt[v_file][1] := step;
                        arr_rlt[v_file][2] := trade;
                        mid_step := mid_step + step;
                        mid_trade := mid_trade + trade;
                        if mode = 1 then begin
                                writeln();
                                writeln('Element comparisons performed: ', step:5);{chislo sravneniy}
                                writeln('Movements of elements performed: ', trade:5); {chislo perestan.}
                                writeln();
                        end;
                end;
                mid_step := mid_step / var_file ;
                mid_trade := mid_trade / var_file;
                write(file_w, '| ',  seq:3 ,  ' | comparisons | ');
                for i := 1 to var_file do write(file_w, arr_rlt[i][1]:6);
                write(file_w, '    |  ', mid_step:7:2 ,  '  |');
                writeln(file_w,'');

                write(file_w, '|   ',  '  |      moving | ');
                for i := 1 to var_file do write(file_w, arr_rlt[i][2]:6);
                write(file_w, '    |  ', mid_trade:7:2 ,  '  |');
                writeln(file_w,'');
                for i := 1 to 69 do write(file_w,'-'); writeln(file_w, '');

        end;

     close(file_w);
     writeln();
     writeln('Last sorted file is saved in: ', f_write);
     writeln('The table with the sorting results is saved in : ', rlt_write);

     end;


begin

        clrscr;

        f_write := 'f_n_up_quick_sort.txt';
        rlt_write := 'Result_quick_sort.txt';

        rlt_mode := init_result; {Vvod rezhima 1 - tablica c rezultatami, 0 - edinichniy rezhim}

        if rlt_mode = 1 then table_write(f_write, rlt_write)
        else begin
                n := init_num;
                f_read := init_file;
                writeln('File read: ', f_read);
                writeln();
                mode := init_working;
                data_read(f_read, n, arr_d);
                q_sort(1, n, n, mode, arr_d, step, trade);
                data_write(f_write, n, arr_d);

                writeln();
                writeln('Element comparisons performed: ', step:5);{chislo sravneniy}
                writeln('Movements of elements performed: ', trade:5); {chislo perestan.}
                writeln();
                writeln('Sorted file is saved in: ', f_write);
        end;
        writeln();
        writeln('Program completed.');
        readln
end.

