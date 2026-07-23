class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.59.0.tar.gz"
  sha256 "d3034477ccd0ccebf18a6bc72d0ba2fb09864eda8a967fabb104c65f2104d4bd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bfc260981075fb8f42e61e2196e8ca13adf5d7eab69968d82248bdd631ddd13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e715246d19b6442b0c2fd45a28b1c318386fe591f12451e38d852289e94a641"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56d1481947e5a9b5278d40b6f0c212be6cdc7038ea92a55491cd78e22d6b6a41"
    sha256 cellar: :any_skip_relocation, sonoma:        "76a1f7bbfcb933c5d5a4767587aeb2c82b566dc0c268371c45d688dca6251626"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3359bfc4914b5c59d7fc75a564d6d3b3aa16e4b4a815496836339bfecc6110ad"
    sha256 cellar: :any,                 x86_64_linux:  "a6cbc1076118382fd446fbe2c3244ddfe902cb45af96940de3a28923a8a34bf3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
