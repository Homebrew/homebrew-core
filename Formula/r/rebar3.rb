class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://rebar3.org"
  url "https://github.com/erlang/rebar3/archive/refs/tags/3.25.0.tar.gz"
  sha256 "7d3f42dc0e126e18fb73e4366129f11dd37bad14d404f461e0a3129ce8903440"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09b1fa318461e2eab3bcf689bf7222e9b436e175707b9a9f152a99d4aa1ea573"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42b1aa6edf2a61ae222c7e64b220eb0c79a24ffaeb637656353919cb0f7f9760"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2377eeb1b0230347cf90ff83fc5a83a49e9ebacd377a944f0b0edf24b1fab5a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b763a7205be3c57fdaa09982fc6a7d00e68407180d7fe02ffe6b054fccd4b2e"
    sha256 cellar: :any_skip_relocation, ventura:       "f78c95b32b5e3828a92229657414cc1e59625f9f1d2f36043a42ecebee3dfb4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3da41e7f6162e36a9e24ca222ccaf5c871559ae11117ec29d47989e3bbf8efee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b64596bc40a4a7d94d73b61a0a659f33d3f907abe85594bb310b4ad3769b1a0"
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
