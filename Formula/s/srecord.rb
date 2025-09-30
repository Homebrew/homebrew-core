class Srecord < Formula
  desc "Tools for manipulating EPROM load files"
  homepage "https://srecord.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/srecord/srecord/1.65/srecord-1.65.0-Source.tar.gz"
  sha256 "81c3d07cf15ce50441f43a82cefd0ac32767c535b5291bcc41bd2311d1337644"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "054d26597b7a4c444cf94c279055aeac127939f40ca58928ccc5a0295c6312d5"
    sha256 cellar: :any,                 arm64_sequoia: "fe9526b920ca097bcc3662d2647c08cfc54a4625a87b2f3a453a4e5f8ad7d23e"
    sha256 cellar: :any,                 arm64_sonoma:  "c84c3f38127465b4d953e34c18f4b3a5b5a54d0f7432473da85a3ca12656530b"
    sha256 cellar: :any,                 arm64_ventura: "8f5734f732be90260ca85621e38461ceb88968f318e5c2fc82c7234c2ea2bc99"
    sha256 cellar: :any,                 sonoma:        "9ccbe261cc839da5b1a89ab3b3bf6db279882ef890c1ad21d2b07b7e2fefafd1"
    sha256 cellar: :any,                 ventura:       "a2bb8ac18cfe099403652f3615826e1166f4f162039f566badd4ff4f93668495"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d56e983fa5e6f74619ff7bd022480f75a8d01d01b560590a01a254fa62b1621f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "930fcefc508d48b013cb7ca445f470176eb0c88f8786a961a4218ca325c1e9ed"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ghostscript" => :build # for ps2pdf
  depends_on "graphviz" => :build
  depends_on "libpaper" => :build # for paper
  depends_on "netpbm" => :build # for pnmcrop
  depends_on "psutils" => :build # for psselect

  depends_on "libgcrypt"

  on_macos do
    depends_on "coreutils" => :build # for ptx
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  # Apply Fedora patch to build shared library and avoid installing a duplicate libgcrypt
  # Issue ref: https://github.com/sierrafoxtrot/srecord/issues/29
  patch do
    url "https://src.fedoraproject.org/rpms/srecord/raw/4d2b7a885e73398fe1caf7fa3d514b522a1bca2f/f/srecord-1.65-fedora.patch"
    sha256 "8e6f0b3f71b99700d598b461272a6926ec5b5445b6758df455aaba02f596c8e9"
  end

  def install
    # Issue ref: https://github.com/sierrafoxtrot/srecord/issues/65
    inreplace "CMakeLists.txt", 'set(CMAKE_INSTALL_PREFIX "/usr")', ""

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove over 40MB of documentation bringing install to 3MB
    rm_r(doc/"htdocs")
  end

  test do
    (testpath/"test.srec").write <<~EOS
      S012000068656C6C6F5F737265632E73726563F2
      S1130000303132333435363738396162636465668A
      S11300104142434445464748494A4B4C4D4E4F5054
      S10C002041414141424242420ABD
      S9030000FC
    EOS

    expected = <<~EOS
      Format: Motorola S-Record
      Header: "hello_srec.srec"
      Execution Start Address: 00000000
      Data:   0000 - 0028
    EOS

    output = shell_output("#{bin}/srec_info #{testpath}/test.srec")
    assert_equal expected, output

    assert_match version.major_minor.to_s, shell_output("#{bin}/srec_info --version")
  end
end
