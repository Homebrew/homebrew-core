class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.8.tar.gz"
  sha256 "0deec62eecc5cffc28f75fe27c735edacbf37ceb81838db59653b205257072b0"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f84c965414601b622ffb9f4163db01e9673b61ff80df19e29649fcfad75302a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f84c965414601b622ffb9f4163db01e9673b61ff80df19e29649fcfad75302a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f84c965414601b622ffb9f4163db01e9673b61ff80df19e29649fcfad75302a"
    sha256 cellar: :any_skip_relocation, sonoma:        "754ea277892b54190fdcf26c3e6d67ebf0346c28e0f0f41cb36abb084eed481e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "972f0e98eaf6b261292f35e6f25f22b492bd32cf37fcb6bd50885ad38933cb0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c50f40d8206c4f238304a4059e8e5245790bfcb1b95b02f077f65928a423f995"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", shell_parameter_format: :cobra)
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
