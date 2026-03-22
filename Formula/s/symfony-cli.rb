class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://github.com/symfony-cli/symfony-cli"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.16.1.tar.gz"
  sha256 "9222ea6c4996c1231577f7475c65902f2eb332ee5249d06c6017218dc35c6a19"
  license "AGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3686f63b764302e774456bf898f2674bedcc295fff45a9f88e9dc229329207f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d618f2a9539c12b70149cb84fa99e3e9be6926cb13610a59dc9339571d1b31de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13ec5b53e97f7f219ea9c1e62dce82936062253a6aa14bd66a50c213bf04f2e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e0389f858e43fb275cf0de8728acaf09b2487f9e09641aa936f9fe9d153d1ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f2af81225d2ab9e606f1fc01ad814469797a3fce2b4cf42125b02834b80942c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b96691de854b7d81284dabc89f3f1ade63e227139a250278578dba99067f67bb"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildDate=#{time.iso8601}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"symfony")

    generate_completions_from_executable(bin/"symfony", "self:completion")
  end

  service do
    run ["#{opt_bin}/symfony", "local:proxy:start", "--foreground"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/symfony self:version")

    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
  end
end
