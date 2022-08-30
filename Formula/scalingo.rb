class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.24.2.tar.gz"
  sha256 "b6ef956fba4c0887b257568bd742a7098f5d98ad62e64e44330c641dd94f7e51"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d388b2b8347d213d2a88de70ccf82d48b0520363cae85c8afa95a1eec5eb4a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "385c419decffa6d1c0095b995ec94961bf049ff2776eb157a9b547b4334b9cda"
    sha256 cellar: :any_skip_relocation, monterey:       "d70077fb67a2f3c94225120d5d0252046daf9f56383f3d2710aa24a8aae6f8e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "01211036323efa0a17189cf5bc87ecf6bf32affddcee098dc5c8647e19821887"
    sha256 cellar: :any_skip_relocation, catalina:       "20d45a265f1349984eff73a3dac4ddd4ffcd29879d2a611e21c5348e6faaeb5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79362837547e76be2ea10318f9a5236452f1653e3cd3929dcd97351285a60c7a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
