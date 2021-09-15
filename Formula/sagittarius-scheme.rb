class SagittariusScheme < Formula
  desc "Free Scheme implementation supporting R6RS and R7RS"
  homepage "https://bitbucket.org/ktakashi/sagittarius-scheme/wiki/Home"
  url "https://bitbucket.org/ktakashi/sagittarius-scheme/downloads/sagittarius-0.9.7.tar.gz"
  sha256 "a8517ef342aadf9fb964e03fd03d4eb13287e5686406ba60d93d6e5c9c91f2a2"
  license "BSD-2-Clause"

  bottle do
    sha256                               big_sur:      "571c191c879cfa536eb60639ad65f82bc30f2782c18ed747dae167254f1e1e8e"
    sha256                               catalina:     "7199d76824cd0de62da70f2eff3db66f0944c2851e4ee868359b7bdbe4685994"
    sha256                               mojave:       "d350853fda37321efe29a14f988b3039126559e489b2fb93a41ca538ca7a2f29"
    sha256                               high_sierra:  "8824ccf2baa439cc953d8b373010e5f00fabb51dd6837f68323993b69549bb84"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e622aaaef6440cec0bb67fc4e4300eac3dff64aaa116ffcd1ab9cc81b9e05ac6"
  end

  depends_on "cmake" => :build
  depends_on "bdw-gc"
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args, "-DODBC_LIBRARIES=odbc"
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/sagittarius -e '(display (+ 1 3))(exit)'")
  end
end
