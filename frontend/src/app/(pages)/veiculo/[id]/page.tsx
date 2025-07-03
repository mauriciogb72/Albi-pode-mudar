export default function VeiculoDetailPage({ params }: { params: { id: string } }) {
  return (
    <div>
      <h1>Detalhes do Veículo</h1>
      <p>Mostrando detalhes para o veículo com ID: {params.id}</p>
    </div>
  );
}
