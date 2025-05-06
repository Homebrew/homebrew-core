class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.23.tar.gz"
  sha256 "4a73ef517470f8106c3ed2dbed09d33e1bb6d2151378d38da6f0088dbfb90bbe"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8b038a4451b694a8b8938bfc1d002da59d7d2b5a3a9660f0570a3e3b33e3823"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8b038a4451b694a8b8938bfc1d002da59d7d2b5a3a9660f0570a3e3b33e3823"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8b038a4451b694a8b8938bfc1d002da59d7d2b5a3a9660f0570a3e3b33e3823"
    sha256 cellar: :any_skip_relocation, sonoma:        "fceaa009ffdcd87c1d39e54ecff87cd01a11f5d6337146c8e1bfe906554c7fee"
    sha256 cellar: :any_skip_relocation, ventura:       "fceaa009ffdcd87c1d39e54ecff87cd01a11f5d6337146c8e1bfe906554c7fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7025ab39fb53f715f97dfe348f5273d3e3ae542ed355f165b7f0c8ace493d63"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
