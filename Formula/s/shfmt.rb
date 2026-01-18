class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "ac15f42feeba55af29bd07698a881deebed1cd07e937effe140d9300e79d5ceb"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f1b1d608e46c6a7ac98efd1bf44b821393f479809ee357f04762b34ee2614b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a4cdf35bd37ddeac3608da2adfc45c2d1b276b9419154d925cfe63b8973035c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a4cdf35bd37ddeac3608da2adfc45c2d1b276b9419154d925cfe63b8973035c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a4cdf35bd37ddeac3608da2adfc45c2d1b276b9419154d925cfe63b8973035c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a7f654ebd0ad605b8f47f4d182e1106050ad6f34cb1b68967d979c54e72e86c"
    sha256 cellar: :any_skip_relocation, ventura:       "2a7f654ebd0ad605b8f47f4d182e1106050ad6f34cb1b68967d979c54e72e86c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a322ef4b30bc6f54f645988c0cb5b4a02887bff693af18f75dbf42bb022adb8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38a4a4aef3735b47289c4d985c8f922b1b96ef9e36232a90d4aa88c80eeb997c"
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
    system "go", "build", *std_go_args(ldflags:), "./cmd/shfmt"
    man1.mkpath
    system "scdoc < ./cmd/shfmt/shfmt.1.scd > #{man1}/shfmt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt --version")

    (testpath/"test").write "\t\techo foo"
    system bin/"shfmt", testpath/"test"
  end
end
