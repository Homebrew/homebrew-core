class Xrdb < Formula
  desc "X resource database utility"
  homepage "https://gitlab.freedesktop.org/xorg/app/xrdb"
  url "https://www.x.org/releases/individual/app/xrdb-1.2.3.tar.xz"
  sha256 "c88f560243278c896ce4fc92ae5a45a2b505a316ffa427fe55b02e5d5914c4e4"
  license all_of: ["MIT-open-group", "HPND-DEC"]

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "de514ce3ca23012eda0c38f03e40c5865bb8ee8a9299b449a3162c61356fcd55"
    sha256 cellar: :any, arm64_tahoe:       "7ddd048d9e571628fea436be64442dae27dbcc875a8d2025299e2881645436c6"
    sha256 cellar: :any, arm64_sequoia:     "4bcb60c61e5d6ba2158bcad4ea980f315a9b2f59ced380856ca9fa6b90bc593a"
    sha256 cellar: :any, arm64_linux:       "8d018863fc1c74a0cad12d182e3b610887bbe2ec2ebe8407845c60151095c8f7"
    sha256 cellar: :any, x86_64_linux:      "9ba83e56d97189302216b1aee508bfcde96f50c3738ad2069e9c1c8a04201fd5"
  end

  depends_on "pkgconf" => :build
  depends_on "xorg-server" => :test

  depends_on "libx11"
  depends_on "libxmu"

  def install
    system "./configure", "--with-cpp=/usr/bin/cpp", *std_configure_args
    system "make", "install"
  end

  test do
    IO.pipe do |read_io, write_io|
      xvfb = formula_opt_bin("xorg-server")/"Xvfb"
      pid = spawn(xvfb, "-displayfd", write_io.fileno.to_s, "-listen", "tcp", write_io => write_io)
      write_io.close
      ENV["DISPLAY"] = ":#{read_io.read.strip}"
      system bin/"xrdb", "-query"
    ensure
      if pid
        Process.kill "TERM", pid
        Process.wait pid
      end
    end
  end
end
