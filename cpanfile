requires "Carp" => "0";
requires "Encode" => "0";
requires "HTTP::Date" => "0";
requires "HTTP::Headers::Util" => "0";
requires "List::Util" => "0";
requires "MIME::Base64" => "0";
requires "Module::Runtime" => "0";
requires "Scalar::Util" => "0";
requires "Sub::Exporter" => "0";
requires "Time::Piece" => "0";
requires "URI::Escape" => "0";
requires "overload" => "0";
requires "parent" => "0";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Spec" => "0";
  requires "HTTP::Headers" => "0";
  requires "HTTP::Request" => "0";
  requires "HTTP::Response" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Test::Fatal" => "0.0003";
  requires "Test::More" => "0.96";
  requires "Test::Warnings" => "0";
  requires "perl" => "5.006";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "Perl::Critic" => "1.123";
  requires "Perl::Tidy" => "20140711";
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::CPAN::Changes" => "0.19";
  requires "Test::EOL" => "0";
  requires "Test::More" => "0.88";
  requires "Test::NoTabs" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Spelling" => "0.12";
  requires "Test::Version" => "1";
};
