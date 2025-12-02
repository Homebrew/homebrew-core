class Supabase < Formula
  desc "Open source Firebase alternative"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v2.62.10.tar.gz"
  sha256 "a769cd6d4b90e836e153e86af51082504b59d4534d64c8cf4ad4ebd086c27731"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7735bd5757861d7f191b66a0aed42d150738e28303fe3359087e10219a3c4eb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ea7b2dd51eedba4bf17ac3ddcbc4c96685a26da192529546659c5531acd68b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cded46eb81fb923572b42e3aa95bc41d74ef4574200b5205cc8986d78e860b82"
    sha256 cellar: :any_skip_relocation, sonoma:        "b87c632732b8297a17c468b4e4634281313bdebd4b2b1192d08c1463685da1c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77d946f38cbab686779da8289ea9b2887d09052cea8c0e98f783da065ff6bd03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a9f91cdecdd3ac8df27129ace3bbafdf98bb8f21ec9b541d8525adc1cd34ade"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/supabase/cli/internal/utils.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"supabase", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase --version")

    system bin/"supabase", "init", "--yes"
    assert_path_exists testpath/"supabase/config.toml"
    assert_match "failed to inspect container health", shell_output("#{bin}/supabase status 2>&1", 1)
    assert_match "Access token not provided", shell_output("#{bin}/supabase projects list 2>&1", 1)
  end
end
