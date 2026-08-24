class Xrdb < Formula
  desc "X resource database utility"
  homepage "https://gitlab.freedesktop.org/xorg/app/xrdb"
  url "https://www.x.org/releases/individual/app/xrdb-1.2.3.tar.xz"
  sha256 "c88f560243278c896ce4fc92ae5a45a2b505a316ffa427fe55b02e5d5914c4e4"
  license all_of: ["MIT-open-group", "HPND-DEC"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9e5d8f010f1d1822fb0e48675ac8a2839c3d3fe0e20b33c5bfce698357e19c07"
    sha256 cellar: :any, arm64_sequoia: "da4838f09bac02e4f36fd8997c1c1ba79a1c77d0791a90b9d92f1783ea964965"
    sha256 cellar: :any, arm64_sonoma:  "d87535873c12a31be875fd75d82e54e20b0889d690e3a36162f62dc991d06e2d"
    sha256 cellar: :any, sonoma:        "3044db43fa489b4975d6391a90839e7fb5b06ed568029e5890b7c569877d1752"
    sha256 cellar: :any, arm64_linux:   "50b322ffd56b13a5241fe4e20baa6b917af04778b85955bdfc821042d0f782f0"
    sha256 cellar: :any, x86_64_linux:  "5c4bb19b0419ed08d31bc8f5942267f63ad518464a267a8e95167b31e84b2b2e"
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
      pid = spawn(Formula["xorg-server"].bin/"Xvfb", "-displayfd", write_io.fileno.to_s, write_io => write_io)
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
