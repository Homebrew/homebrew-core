class Soapysdr < Formula
  desc "Vendor and platform neutral SDR support library"
  homepage "https://github.com/pothosware/SoapySDR/wiki"
  url "https://github.com/pothosware/SoapySDR/archive/refs/tags/soapy-sdr-0.9.0.tar.gz"
  sha256 "64f97c1ad241156fe299acb8902169019eab34517cd580b563968a43d7533509"
  license "BSL-1.0"
  compatibility_version 1
  head "https://github.com/pothosware/SoapySDR.git", branch: "master"

  bottle do
    rebuild 1
    sha256               arm64_golden_gate: "03ad4b177ad980188fce89ccc390525225c5524fc98aebb84ff364490b06db09"
    sha256               arm64_tahoe:       "7cc27887c271fee034f0aa63c2130059ac39349f3443da4b84e24f591a45339d"
    sha256               arm64_sequoia:     "e098f6a65671bacfdf27830af5bc5518c386fac38ce0965d3e3aec58967dd993"
    sha256               arm64_linux:       "1bd333b6d699d20d320a31cde93d0f4a40aee307a365a4d0f0640b368c89e458"
    sha256 cellar: :any, x86_64_linux:      "05c6f575acd7c76017f3890f07e99bfce5f828c14b36e248aeb391e150ab72eb"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python@3.15"

  deny_network_access!

  def install
    args = %W[
      -DPython3_EXECUTABLE=#{python3}
      -DSOAPY_SDR_ROOT=#{HOMEBREW_PREFIX}
    ]
    args << "-DSOAPY_SDR_EXTVER=release" if build.stable?

    site_packages = prefix/Language::Python.site_packages(python3)
    args << "-DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: site_packages)}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Loading modules... done", shell_output("#{bin}/SoapySDRUtil --check=null")
    system python3, "-c", "import SoapySDR"
  end
end
