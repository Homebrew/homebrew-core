class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://rebar3.org"
  url "https://github.com/erlang/rebar3/archive/refs/tags/3.26.0.tar.gz"
  sha256 "a151dc4a07805490e9f217a099e597ac9774814875f55da2c66545c333fdff64"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91f97c1a0c766bd4bd606dd905d2015fab02177682a4b254b0717ed1b2281218"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f888fa980daebaefdb7270b40c2a16fcf4d2e4c8679bd27e684e35add3c51652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94841cc4ffd844b7601b303f0eaf8b232147db461f640514c117d4772a5ee13d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0151a43fbb9c46a54ebfcf369aa0d0b9b39249ef706e53e2d2440964ff773cd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3dccde1cbdf81c504b0f66a3074c7eb1a70140f3d64ef00d6a43ca7303db88a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58d9bc37a3f42bf0264e3f4d8fac7d97166a021a94918d731c4a9937e8439cc5"
  end

  depends_on "erlang@26" => [:build, :test]
  depends_on "erlang"

  def install
    erlang_build_dep = deps.find { |dep| dep.build? && dep.name.match?(/^erlang@\d+$/) }&.to_formula
    odie "Could not find build-time erlang!" if erlang_build_dep.blank?

    # To guarantee compatibility with various erlang versions, build with an older erlang.
    # We want to use `erlang@#{x-2}` where x is the major version of the `erlang` formula.
    build_erlang_version = erlang_build_dep.version.major.to_i
    wanted_erlang_version = Formula["erlang"].version.major.to_i - 2
    if wanted_erlang_version != build_erlang_version
      odie "This formula should be built with `erlang@#{wanted_erlang_version}`"
    end

    # Ensure we're building with versioned `erlang`
    ENV.remove "PATH", "#{Formula["erlang"].opt_bin}:"
    system "./bootstrap"
    bin.install "rebar3"

    bash_completion.install "apps/rebar/priv/shell-completion/bash/rebar3"
    zsh_completion.install "apps/rebar/priv/shell-completion/zsh/_rebar3"
    fish_completion.install "apps/rebar/priv/shell-completion/fish/rebar3.fish"
  end

  test do
    deps.each do |dep|
      next unless dep.name.match?(/^erlang(@\d+)?$/)

      erlang = dep.to_formula
      erlang_bin = erlang.opt_bin
      erlang_version = erlang.version.major
      with_env(PATH: "#{erlang_bin}:#{ENV["PATH"]}") do
        assert_match "OTP #{erlang_version}", shell_output("#{bin}/rebar3 --version")
      end
    end
  end
end
