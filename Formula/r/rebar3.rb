class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://rebar3.org"
  url "https://github.com/erlang/rebar3/archive/refs/tags/3.27.0.tar.gz"
  sha256 "985cae6e957334cfa549190b9f5efb9185c184a18fc181c87b8dde096ba79f38"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "197a84b47739f53fdad86802701343503cf5e2f29679d6d471f10c01593ee176"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf5a9f0d9cd01805c8cc1a985e4d702638911d4364770f3734898e183c358fba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b75f7c470bf26337b63def63e6b02bb610b6d1ccb8fcae5b256ac9bf75c8c16b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8581adc38827a457b4811dd6ed82c7e3e0a6439892c9fff692c6de1098394d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6882937c20792209d1cad1c23ce0cab1d971faf184f021482f30b675d261dc85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "106d9656022f800b514743fd657fdc4a4a73d0dea82e036780da401d4b1bbb83"
  end

  depends_on "erlang@27" => [:build, :test]
  depends_on "erlang" => :test

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
