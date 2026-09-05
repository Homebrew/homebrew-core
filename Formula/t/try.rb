class Try < Formula
  desc "Quickly manage and navigate project directories for experiments"
  homepage "https://github.com/tobi/try"
  url "https://github.com/tobi/try/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "4520a71a2485e04b09a93514d4818ad24800ea4738b8dceba24e941cbe2fc879"
  license "MIT"
  head "https://github.com/tobi/try.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cdbdc391c8eeb6f51ec4bcf5a621dc12b75a5de804fc3f8713ece0be14f491a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cdbdc391c8eeb6f51ec4bcf5a621dc12b75a5de804fc3f8713ece0be14f491a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cdbdc391c8eeb6f51ec4bcf5a621dc12b75a5de804fc3f8713ece0be14f491a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cdbdc391c8eeb6f51ec4bcf5a621dc12b75a5de804fc3f8713ece0be14f491a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "747851a45c2d27d22c880e6bfbc037f3743c65e54427ae5dd1eee64a92d948c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "747851a45c2d27d22c880e6bfbc037f3743c65e54427ae5dd1eee64a92d948c8"
  end

  depends_on "ruby"

  deny_network_access!

  def install
    ENV["GEM_HOME"] = libexec

    gem_name = "try-cli"
    system "bundle", "install", "--local"
    system "gem", "build", "#{gem_name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{gem_name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    try_dir = "#{Dir.pwd}/src/tries/#{Date.today.iso8601}-tobi-try"
    expected_mkdir_command = "mkdir -p '#{try_dir}'"
    expected_clone_command = "git clone 'https://github.com/tobi/try.git' '#{try_dir}'"
    expected_cd_command = "cd '#{try_dir}'"
    output = shell_output("#{bin}/try exec clone https://github.com/tobi/try.git").chomp
    assert_match expected_mkdir_command, output
    assert_match expected_clone_command, output
    assert_match expected_cd_command, output
  end
end
