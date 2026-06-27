class Svu < Formula
  desc "Semantic version utility"
  homepage "https://github.com/caarlos0/svu"
  url "https://github.com/caarlos0/svu/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "b40fe73b43926051885045cdf72a3882d3b5e4826577532bd95ef15a9313e418"
  license "MIT"
  head "https://github.com/caarlos0/svu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fbb8d4392171c75d6949b322d900a4f8bdee26f714a9c4250f5e8dea22d43bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fbb8d4392171c75d6949b322d900a4f8bdee26f714a9c4250f5e8dea22d43bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fbb8d4392171c75d6949b322d900a4f8bdee26f714a9c4250f5e8dea22d43bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bf2db740cb081a92a5e619945631bf9cd2aba7a047442ce2ea42ac62d1fb732"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1da09dc2baa8695ebe3cdb32f36829ff438c85671a890db2bbbd8efeb3280fe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "100a92ac58251333d989171e67366067965e3fb4e2546df4693ea71e44167427"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user} -X main.treeState=clean"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"svu", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/svu --version")
    system bin/"svu", "init"
    assert_match "svu configuration", (testpath/".svu.yml").read
  end
end
