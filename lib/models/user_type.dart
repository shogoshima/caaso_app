enum UserType {
  aloja('Alune do Aloja'),
  grad('Alune da graduação'),
  postgrad('Alune da pós-graduação'),
  other('Outro (ex-alunes, professores)');

  const UserType(this.value);
  final String value;
}
