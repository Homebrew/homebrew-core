class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.8.3.tar.gz"
  sha256 "5568f9987b6d26535c0e7a427158848f1bc03d829f74e41cbcf007d8704e9bd3"
  license "BSD-4-Clause"
  head "https://github.com/andmarti1424/sc-im.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "75f632db6ed4794e25cebcc46c023255be662b3aafa09e457629adb83b87e2e9"
    sha256 arm64_monterey: "a19adff4e5f065abc68995fdc338fb16d0a9cc77857eaf69724826e8d0b9f0fd"
    sha256 arm64_big_sur:  "f2f0c70eaf59e601836c64622f3dcb9f07152f1744ab1325ff97cba36e7f0b8f"
    sha256 ventura:        "39afae40b8fe65bb8acf478ab9eb7f58106c98b7237342055879ab2969156c8e"
    sha256 monterey:       "84fa70f78bdaff7c0f6d8ee2e5a5ebc0454114c5a582b0fbf6bffcabbccf9899"
    sha256 big_sur:        "00f0fe5c274b84d3780032f7cc96ca7a3f6173ac97e26adc53978ec36187f8d2"
    sha256 x86_64_linux:   "a55c207ca7b4c572c0890c86f254933133d49605a3adbf2e2b79c07f4ea82b6a"
  end

  depends_on "pkg-config" => :build
  depends_on "libxls"
  depends_on "libxlsxwriter"
  depends_on "libxml2"
  depends_on "libzip"
  depends_on "lua"
  depends_on "ncurses"

  uses_from_macos "bison" => :build

  def install
    # Enable plotting with `gnuplot` if available.
    ENV.append_to_cflags "-DGNUPLOT"

    cd "src" do
      inreplace "Makefile" do |s|
        # Increase `MAXROWS` to the maximum possible value.
        # This is the same limit that Microsoft Excel has.
        s.gsub! "MAXROWS=65536", "MAXROWS=1048576"
        if OS.mac?
          # Use `pbcopy` and `pbpaste` as the default clipboard commands.
          s.gsub!(/^CFLAGS.*(xclip|tmux).*/, "#\\0")
          s.gsub!(/^#(CFLAGS.*pb(copy|paste).*)$/, "\\1")
        end
      end
      system "make", "prefix=#{prefix}"
      system "make", "prefix=#{prefix}", "install"
    end
  end

  test do
    input = <<~EOS
      let A1=1+1
      recalc
      getnum A1
    EOS
    output = pipe_output(
      "#{bin}/sc-im --nocurses --quit_afterload 2>/dev/null", input
    )
    assert_equal "2", output.lines.last.chomp
  end
end
