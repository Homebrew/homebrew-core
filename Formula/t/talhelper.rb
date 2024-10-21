class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.7.tar.gz"
  sha256 "1abb6370414f41a1a725337d85dba483b5f393d6b702109d874cf4b16e7878b6"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3421690810179e420cf81d35991a09f892ea8a284fb1bb2fd98323287f5741be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3421690810179e420cf81d35991a09f892ea8a284fb1bb2fd98323287f5741be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3421690810179e420cf81d35991a09f892ea8a284fb1bb2fd98323287f5741be"
    sha256 cellar: :any_skip_relocation, sonoma:        "52f9afed4f7610a0ed0bf3db3330296767a78f5a39dae325bc5f93630820e910"
    sha256 cellar: :any_skip_relocation, ventura:       "52f9afed4f7610a0ed0bf3db3330296767a78f5a39dae325bc5f93630820e910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3acf7f43ae37f6b5217ca064c68773b380e849c919e36129e214c159c23b9aa2"
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
