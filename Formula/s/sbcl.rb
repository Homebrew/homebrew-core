class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.4.1/sbcl-2.4.1-source.tar.bz2"
  sha256 "da4f9486fad413d3af7abb1b09269325fdb4bff7e7b88f2195ddee743263cf7e"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8c0f47b1ae0fffae4278e697cdb67ef5544f33a7f86179d0e65a97f783cbd99d"
    sha256 cellar: :any,                 arm64_ventura:  "4d44eb9a24d4b3866d9f8877b33424bb7b555cc8d6cad15b999cf015f0590057"
    sha256 cellar: :any,                 arm64_monterey: "7134826860f3d1161472c59ff7d79e7b3a373d15a2c86e1d90af856c7a1a4e28"
    sha256 cellar: :any,                 sonoma:         "452f2d75f281d1ef62e2dc901a10c3202d007c5b550ba37b3fff4698f027c1f4"
    sha256 cellar: :any,                 ventura:        "dab57f8bb0058c8a16a9b5e664bfa266434f671b02cc539d2ae269566d251f7b"
    sha256 cellar: :any,                 monterey:       "f2da9ba8b2e4de7fe79aa6691960c5110ec9105ea83c4117e175ae8970df451b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "168a3399cd14e2436e02f115b37bbcce0b017d083d1b075cf7388ff8841ba154"
  end

  depends_on "ecl" => :build
  depends_on "zstd"

  def install
    # Remove non-ASCII values from environment as they cause build failures
    # More information: https://bugs.gentoo.org/show_bug.cgi?id=174702
    ENV.delete_if do |_, value|
      ascii_val = value.dup
      ascii_val.force_encoding("ASCII-8BIT") if ascii_val.respond_to? :force_encoding
      ascii_val =~ /[\x80-\xff]/n
    end

    xc_cmdline = "ecl --norc"

    args = [
      "--prefix=#{prefix}",
      "--xc-host=#{xc_cmdline}",
      "--with-sb-core-compression",
      "--with-sb-ldb",
      "--with-sb-thread",
    ]

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version.to_s if OS.mac?
    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    # Install sources
    bin.env_script_all_files libexec/"bin",
                             SBCL_SOURCE_ROOT: pkgshare/"src",
                             SBCL_HOME:        lib/"sbcl"
    pkgshare.install %w[contrib src]
    (lib/"sbcl/sbclrc").write <<~EOS
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    EOS
  end

  test do
    (testpath/"simple.sbcl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
