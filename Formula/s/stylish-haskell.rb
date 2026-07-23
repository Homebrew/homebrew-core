class StylishHaskell < Formula
  desc "Haskell code prettifier"
  homepage "https://github.com/haskell/stylish-haskell"
  url "https://github.com/haskell/stylish-haskell/archive/refs/tags/v0.15.1.0.tar.gz"
  sha256 "0187bb335205f6b5c9c78d3fc27deb59ce7122c7eb7429b88971d8cb25d7be51"
  license "BSD-3-Clause"
  head "https://github.com/haskell/stylish-haskell.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "375b12aeb5ec9d70bc4cb78b291fc68a5d8afc3e057c93e9a7375c7d022b3931"
    sha256 cellar: :any, arm64_sequoia: "d4c31632c556e1a0c92b7099396052efe0501f058675639fb4182e28573e61d3"
    sha256 cellar: :any, arm64_sonoma:  "0cc9f3d577e76813d02f754020f30eefaa12d2f0356f2d01f8df36dfe560d17a"
    sha256 cellar: :any, sonoma:        "a499060dd46b6b6fca715e861b1a8ce10b4c80f040db8e98007f4a719952682f"
    sha256 cellar: :any, arm64_linux:   "9e7417fa6700b9304a1a9a3134e862bc4862cfc68882842588574a1e3ece0ef2"
    sha256 cellar: :any, x86_64_linux:  "2b4f585f1b1ff99393bbb6734af0a3561e0dc5de1f33a1625bc78a09f85feb9f"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

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
    assert_equal expected, shell_output("#{bin}/stylish-haskell test.hs")
  end
end
