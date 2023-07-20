# cub3d-tester
A simple parser tester for cub3d

### Installation

Do ```cd <path_to_cub3d>```

Now you can clone this repository with

```bash
git clone https://github.com/Aldisti/cub3d-tester.git
```

## Usage

When you want to run the tester you have to enter its folder ```cd cub3d-tester```
and you can launch the tester with
```bash
./test.sh
```
or
```bash
sh test.sh
```

## Output

The tester will tell you in real time how many tests have passed and which have not.
Furthermore, once all the tests have been performed, a folder (out) will be created with the passed map and the output it gave.
The file will be named 'out<map_number>.out' and the map and output will be separated by some '#'s.

### Pro tip

If the out file after the '#'s is empty, then your cub3d didn't recognize the error.

## Bug report

If you find some bugs or errors of any type, please, report them to me. You can
contact me on slack: @adi-stef
