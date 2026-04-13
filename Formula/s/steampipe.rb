class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "b2eebf71c3e2340b987c7bb992733ee1913e0619faead2309f37a02cb6b54c66"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c7f461ded24423a45db368eefa99bb32cb54f68db5504a8029f71a02e199b91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "070d80940058b638eae63b95c8109e9eea6a4f61fe7d66b6fe7081d5f2bd5929"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "241ef56d9025f07650d4c906210f4bde2928aad2ff8749f4162673097d15c26d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f018a40f37218294641a36a98daddd0814c5f634fbd3247996d7e05de5c80ab3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "770ed0e23345b29d5f2e7cd435d60efb4a644db1dfe12cf13d9af00728cff8b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "298e8ceaca1994aa70be0333591db40f872cc6ca055986942aa4268e5bc2b098"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"steampipe", shell_parameter_format: :cobra)
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match "Steampipe v#{version}", shell_output("#{bin}/steampipe --version")
  end
end
