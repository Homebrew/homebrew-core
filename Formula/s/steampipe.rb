class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "3ec49ac9387debf779613ca8843792dbd10a88bfeb3c0af17eab88ebcc5774ab"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf916f73334044f910449032e00fc7793009c40ad032f961a6dc32f5ad89b0d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b8d9a24fab3e7346f12760aac96076a3f26c31526c52655acdee83cfbf68c49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5573f6292e2f31587b9d0fadc1f98c7938d0a6c946fd61ceea288d99dd7d940b"
    sha256 cellar: :any_skip_relocation, sonoma:        "354c8d4e33e722329e4f7d074239625321c5ed0eec63b385446e7b4a301df5c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "187d776e167e1a751540c8ab60951b260276e7333c0870a9854b3c7ac9e52660"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match "Steampipe v#{version}", shell_output("#{bin}/steampipe --version")
  end
end
