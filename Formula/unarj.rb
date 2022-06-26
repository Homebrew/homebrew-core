class Unarj < Formula
  desc "ARJ file archiver"
  homepage "http://www.arjsoftware.com/files.htm"
  url "https://src.fedoraproject.org/repo/pkgs/unarj/unarj-2.65.tar.gz/c6fe45db1741f97155c7def322aa74aa/unarj-2.65.tar.gz"
  sha256 "d7dcc325160af6eb2956f5cb53a002edb2d833e4bb17846669f92ba0ce3f0264"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2de1efe29a501d00894c72615a3e8a81de02f3322965378a7c1fcff715968541"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba5ca05683704cf902159fbba1c6f81fcb45e3b97d2af79b393d2fa9147a4449"
    sha256 cellar: :any_skip_relocation, monterey:       "75571ca079bf2794aa886c1e3623e241b48219eaa0778394b791673ceb06eb17"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2cdb9fae2941778b986c52e8d6e5f11654a4e741ce785e093780adcb6f8031d"
    sha256 cellar: :any_skip_relocation, catalina:       "ec9937cacc782782b33064f5a0ea90b95fed66cb9ba86fad405c8e5f0056c53e"
    sha256 cellar: :any_skip_relocation, mojave:         "e7459bb6bae23b6b6b8a7bfcd2a869275903f243e755440709eb5b550783f88a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "3b7158daf585ed94c61106abb7cbfc956f1a918e4d185ffaa89c755b1c9deba6"
    sha256 cellar: :any_skip_relocation, sierra:         "44c4722b1e3d30d987bcbd9fc9ccd7015c54d087bedb7da030e50cc84d0a52e6"
    sha256 cellar: :any_skip_relocation, el_capitan:     "7bdcd771f852f59915623dae370c8f807cbf20f242dad60d62afa1dc683cdf4a"
    sha256 cellar: :any_skip_relocation, yosemite:       "95794638930505f1d4a23553571d62de07dd3f62da7687ef571c6f7e893bba42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adc76dba3257db6f81cb4a5d57a56cce3c525f3e0254609d3248a0472d699d9b"
  end

  resource "testfile" do
    url "https://s3.amazonaws.com/ARJ/ARJ286.EXE"
    sha256 "e7823fe46fd971fe57e34eef3105fa365ded1cc4cc8295ca3240500f95841c1f"
  end

  def install
    system "make"
    bin.mkdir
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    # Ensure that you can extract arj.exe from a sample self-extracting file
    resource("testfile").stage do
      system "#{bin}/unarj", "e", "ARJ286.EXE"
      assert_predicate Pathname.pwd/"arj.exe", :exist?
    end
  end
end
