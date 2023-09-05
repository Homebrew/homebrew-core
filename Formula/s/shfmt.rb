class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.7.0.tar.gz"
  sha256 "89eafc8790df93305dfa42233e262fb25e1c96726a3db420a7555abadf3111ed"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42d7b97c10e8378bc847d931c430d0c4d99e142e9a7595b49479bd16a29883ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "853a6e80df2c5de039c74f72e83bb2aa03ec90ff7bb8e41af8bba47b8c644e5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f760d5abd5b728bbaee70f910b9fe22725a29c67bfdb615e10f3bd54b85504e"
    sha256 cellar: :any_skip_relocation, ventura:        "8149b3133602e0f066388162cece401ced30f66f866340aabfb9e0381e6a7731"
    sha256 cellar: :any_skip_relocation, monterey:       "36a7e4bbf11144fe191d4932122e51ae0076223e7fa8731794152bd31a93d917"
    sha256 cellar: :any_skip_relocation, big_sur:        "36150afd02ba42d406a546eb7454e4dccdbda0e3931d7dc45d8542ad81e2b21f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8724c77482a24054ee4c353340a216ac36d5ff9afa2e8907be8aab711825fae"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -extldflags=-static
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/shfmt"
    man1.mkpath
    system "scdoc < ./cmd/shfmt/shfmt.1.scd > #{man1}/shfmt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt --version")

    (testpath/"test").write "\t\techo foo"
    system bin/"shfmt", testpath/"test"
  end
end
