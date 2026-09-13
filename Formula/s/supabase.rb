class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v2.117.0.tar.gz"
  sha256 "630de8f7edba860d85a4ca303731241bf7ae96267c00d99a7f7d0496164cee1c"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_golden_gate: "e54ef1199887c1674dc80551cdd81641fa493cc8a7a1e24c2631aba8389459ea"
    sha256                               arm64_tahoe:       "e54ef1199887c1674dc80551cdd81641fa493cc8a7a1e24c2631aba8389459ea"
    sha256                               arm64_sequoia:     "e54ef1199887c1674dc80551cdd81641fa493cc8a7a1e24c2631aba8389459ea"
    sha256                               arm64_sonoma:      "e54ef1199887c1674dc80551cdd81641fa493cc8a7a1e24c2631aba8389459ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9d69dd191a534fb909a419936f4b53ad8ff9b78f15fafeebe1d9d98d611b0c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ca1320a8cbe19d8ab9c1be92bfe7defb9eeafef158eb1e31bd271eb223ebf48c"
  end

  depends_on "bun" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "icu4c@78"
  end

  def install
    system "pnpm", "install", "--frozen-lockfile", "--ignore-scripts"

    # plpgsql-deparser imports @libpg-query/parser without declaring it, which pnpm's
    # global virtual store cannot resolve. Link it in rather than patching
    # pnpm-workspace.yaml, which would invalidate the lockfile.
    deparser = (buildpath/"node_modules/.pnpm/node_modules/plpgsql-deparser").realpath
    parser = (buildpath/"node_modules/.pnpm/node_modules/@libpg-query/parser").realpath
    (deparser/"node_modules/@libpg-query").mkpath
    ln_sf parser, deparser/"node_modules/@libpg-query/parser"

    # The tag archive carries a placeholder version; upstream inject the real one at release.
    system "bun", "apps/cli/scripts/sync-versions.ts", "--version", version.to_s

    libexec.mkpath
    ldflags = "-X github.com/supabase/cli/internal/utils.Version=#{version}"
    cd "apps/cli-go" do
      system "go", "build", *std_go_args(output: libexec/"supabase-go", ldflags:)
    end

    cd "apps/cli" do
      system "bun", "scripts/build-binary.ts"
      libexec.install "dist/supabase-legacy" => "supabase"
    end

    # supabase-go must stay next to the shell binary: it is resolved relative to
    # process.execPath (apps/cli/src/shared/legacy/go-proxy.layer.ts).
    bin.install_symlink libexec/"supabase"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase --version")

    system bin/"supabase", "init", "--yes"
    assert_path_exists testpath/"supabase/config.toml"
    assert_match "failed to inspect container health", shell_output("#{bin}/supabase status 2>&1", 1)
    assert_match "Access token not provided", shell_output("#{bin}/supabase projects list 2>&1", 1)
  end
end
