class StylishHaskell < Formula
  desc "Haskell code prettifier"
  homepage "https://github.com/haskell/stylish-haskell"
  url "https://github.com/haskell/stylish-haskell/archive/refs/tags/v0.15.1.0.tar.gz"
  sha256 "0187bb335205f6b5c9c78d3fc27deb59ce7122c7eb7429b88971d8cb25d7be51"
  license "BSD-3-Clause"
  head "https://github.com/haskell/stylish-haskell.git", branch: "main"

  bottle do
    rebuild 4
    sha256 cellar: :any, arm64_tahoe:   "a4f78bcd8ce59aec4e06a0cfc88954a75684ebb8305ac5e0c58e45e79a21c66c"
    sha256 cellar: :any, arm64_sequoia: "b1e5697193a7f1cf3b72032cd8979406c074fba9f016eeeb189bc64b1ff807f7"
    sha256 cellar: :any, arm64_sonoma:  "437113d6529d3f00612edff31bb8b89b4c149754c47884b3b5a66026b434c698"
    sha256 cellar: :any, sonoma:        "0c9c411096f25025890fc55cb4825ff6c6e502e831322ebcac7682bfba7453a2"
    sha256 cellar: :any, arm64_linux:   "56ff3634ea64b1be1fc7c5fb0eaef1ed7dc0571502c1b15386f7ab2bec84fc6b"
    sha256 cellar: :any, x86_64_linux:  "413b44a4bc58973d5568bfdaf4d18092707c83802879d30cdcfb3917f3c16083"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  # Support Cabal 3.18
  patch do
    url "https://github.com/haskell/stylish-haskell/commit/8982d5ebb30fd26afffc6a4bb4c7757891ee8c86.patch?full_index=1"
    sha256 "6be3185315aeff68f05c2539376f3ab0b1e3ac858913fd1d888f2d3e7d8a50dd"
    type :unofficial
    resolves "https://github.com/haskell/stylish-haskell/pull/502"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~HASKELL
      {-# LANGUAGE ViewPatterns, TemplateHaskell #-}
      {-# LANGUAGE GeneralizedNewtypeDeriving,
                  ViewPatterns,
          ScopedTypeVariables #-}

      module Bad where

      import Control.Applicative ((<$>))
      import System.Directory (doesFileExist)

      import qualified Data.Map as M
      import      Data.Map    ((!), keys, Map)
    HASKELL
    expected = <<~HASKELL
      {-# LANGUAGE GeneralizedNewtypeDeriving #-}
      {-# LANGUAGE ScopedTypeVariables        #-}
      {-# LANGUAGE TemplateHaskell            #-}

      module Bad where

      import           Control.Applicative ((<$>))
      import           System.Directory    (doesFileExist)

      import           Data.Map            (Map, keys, (!))
      import qualified Data.Map            as M
    HASKELL
    # Pass the config explicitly; searching for one walks up to `/`, which the sandbox denies
    (testpath/"config.yaml").write shell_output("#{bin}/stylish-haskell --defaults")

    assert_equal expected, shell_output("#{bin}/stylish-haskell --config config.yaml test.hs")
  end
end
